import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_model.dart';

enum SessionState { loading, ready, playing, paused, finished, error }

class SessionProvider with ChangeNotifier {
  SessionState _sessionState = SessionState.loading;
  YogaSession? _yogaSession;
  int _currentSequenceIndex = 0;
  int _currentScriptIndex = 0;
  int _loopCount = 0;
  Timer? _sessionTimer;
  double _progress = 0.0;
  final AudioPlayer _instructionPlayer = AudioPlayer();
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  bool _isBackgroundMusicPlaying = false;
  int _streakCount = 0;

  StreamSubscription<void>? _playerCompleteSubscription;

  SessionProvider() {
    _initializeAudioPlayer();
    _loadSessionData();
    _loadStreakCount();
  }

  void _initializeAudioPlayer() {
    _instructionPlayer.onPlayerStateChanged.listen((state) {
      debugPrint('Audio player state changed: $state');
    });
    _instructionPlayer.onPlayerComplete.listen((_) {
      debugPrint('Audio player completed playback');
      _moveToNextSequence();
    });
  }

  SessionState get sessionState => _sessionState;
  YogaSession? get yogaSession => _yogaSession;
  SequenceItem? get currentSequence =>
      _yogaSession?.sequence[_currentSequenceIndex];
  ScriptItem? get currentScript => currentSequence?.script[_currentScriptIndex];
  bool get isPlaying => _sessionState == SessionState.playing;
  double get progress => _progress;
  String get instructionText => currentScript?.text ?? "Loading session...";
  String get currentImagePath {
    if (_yogaSession == null || currentScript == null) {
      return 'assets/images/Base.png';
    }
    final imageKey = currentScript!.imageRef;
    final imageName = _yogaSession!.assets.images[imageKey];
    if (imageName != null) {
      if (imageName.startsWith('assets/images/')) {
        return imageName;
      } else if (imageName.startsWith('images/')) {
        return imageName.replaceFirst('images/', 'assets/images/');
      } else {
        return 'assets/images/$imageName';
      }
    }
    return 'assets/images/Base.png';
  }

  bool get isBackgroundMusicPlaying => _isBackgroundMusicPlaying;
  int get streakCount => _streakCount;

  Future<void> _loadStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    _streakCount = prefs.getInt('streakCount') ?? 0;
    notifyListeners();
  }

  Future<void> _saveStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streakCount', _streakCount);
  }

  void toggleBackgroundMusic() {
    if (_isBackgroundMusicPlaying) {
      _backgroundMusicPlayer.pause();
      _isBackgroundMusicPlaying = false;
    } else {
      _playBackgroundMusic();
      _isBackgroundMusicPlaying = true;
    }
    notifyListeners();
  }

  Future<void> _playBackgroundMusic() async {
    if (_yogaSession == null) return;
    final bgMusicFile = _yogaSession!.assets.audio['background'];
    if (bgMusicFile == null) return;
    final bgMusicPath = 'audio/$bgMusicFile';
    try {
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.play(AssetSource(bgMusicPath), volume: 0.3);
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  void startOrResumeSession() {
    if (_sessionState == SessionState.ready ||
        _sessionState == SessionState.finished) {
      _sessionState = SessionState.playing;
      _playCurrentSequence();
      _startTimer();
    } else if (_sessionState == SessionState.paused) {
      _sessionState = SessionState.playing;
      _instructionPlayer.resume();
      _startTimer();
    }
    notifyListeners();
  }

  void pauseSession() {
    if (_sessionState == SessionState.playing) {
      _sessionState = SessionState.paused;
      _sessionTimer?.cancel();
      _instructionPlayer.pause();
      notifyListeners();
    }
  }

  void stopAndResetSession() {
    _sessionState = SessionState.ready;
    _sessionTimer?.cancel();
    _instructionPlayer.stop();
    _currentSequenceIndex = 0;
    _currentScriptIndex = 0;
    _progress = 0.0;
    _loopCount = 0;
    notifyListeners();
  }

  Future<void> _loadSessionData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/script.json');
      _yogaSession = yogaSessionFromJson(jsonString);
      _sessionState = SessionState.ready;
    } catch (e) {
      _sessionState = SessionState.error;
      debugPrint("Error loading session data: $e");
    }
    notifyListeners();
  }

  void _playCurrentSequence() {
    if (currentSequence == null) return;
    final audioKey = currentSequence!.audioRef;
    final audioFileName = _yogaSession!.assets.audio[audioKey];
    debugPrint('Playing audio file: $audioFileName');
    if (audioFileName == null) return;
    final audioPath = 'audio/$audioFileName';
    _instructionPlayer.play(AssetSource(audioPath)).then((_) {
      debugPrint('Audio play started');
    }).catchError((error) {
      debugPrint('Audio play error: $error');
    });
  }

  void _startTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (_sessionState != SessionState.playing || currentSequence == null) {
        timer.cancel();
        return;
      }
      try {
        await _updateProgress();
        await _updateScriptIndex();
        notifyListeners();
      } catch (e) {
        debugPrint('Error in timer callback: $e');
        timer.cancel();
      }
    });
  }

  Future<void> _updateProgress() async {
    final position = await _instructionPlayer.getCurrentPosition();
    final duration = await _instructionPlayer.getDuration();
    if (position != null && duration != null && duration.inMilliseconds > 0) {
      _progress =
          (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    }
  }

  Future<void> _updateScriptIndex() async {
    final position = await _instructionPlayer.getCurrentPosition();
    if (position == null || currentSequence == null) return;
    final newScriptIndex = currentSequence!.script
        .lastIndexWhere((item) => item.startSec <= position.inSeconds);
    if (newScriptIndex != -1 && newScriptIndex != _currentScriptIndex) {
      _currentScriptIndex = newScriptIndex;
      notifyListeners();
    }
  }

  void _moveToNextSequence() {
    if (currentSequence?.type == 'loop' &&
        _loopCount < (_yogaSession?.metadata.defaultLoopCount ?? 1) - 1) {
      _loopCount++;
      _currentScriptIndex = 0;
      _playCurrentSequence();
    } else {
      if (_currentSequenceIndex < _yogaSession!.sequence.length - 1) {
        _currentSequenceIndex++;
        _currentScriptIndex = 0;
        _loopCount = 0;
        _playCurrentSequence();
      } else {
        _sessionState = SessionState.finished;
        _progress = 1.0;
        _instructionPlayer.stop();
        _incrementStreak();
      }
    }
    notifyListeners();
  }

  void _incrementStreak() {
    _streakCount++;
    _saveStreakCount();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _playerCompleteSubscription?.cancel();
    _instructionPlayer.dispose();
    _backgroundMusicPlayer.dispose();
    super.dispose();
  }
}
