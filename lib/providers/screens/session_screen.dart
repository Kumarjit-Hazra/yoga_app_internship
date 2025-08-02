import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/session_provider.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        
        return WillPopScope(
          onWillPop: () async {
            session.stopAndResetSession();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              
              title: Text(session.yogaSession?.metadata.title ?? 'Yoga Session'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  session.stopAndResetSession();
                  Navigator.of(context).pop();
                },
              ),
            ),
            
            body: _buildBody(context, session),
          ),
        );
      },
    );
  }

  
  Widget _buildBody(BuildContext context, SessionProvider session) {
    switch (session.sessionState) {
      case SessionState.loading:
        return const Center(child: CircularProgressIndicator());
      case SessionState.error:
        return const Center(
            child: Text('Failed to load session. Check asset paths.'));
      case SessionState.ready:
      case SessionState.playing:
      case SessionState.paused:
      case SessionState.finished:
        return _buildSessionUI(context, session);
      default:
        return const Center(child: Text('An unknown error occurred.'));
    }
  }

 
  Widget _buildSessionUI(BuildContext context, SessionProvider session) {
    final isFinished = session.sessionState == SessionState.finished;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 40, 
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(session.currentImagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Text(
                            isFinished ? "Session Complete!" : session.instructionText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
              SizedBox(
                width: double.infinity,
                child: LinearProgressIndicator(
                  value: session.progress,
                  backgroundColor: Colors.grey[800],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF8A3FFC)),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Background Music',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Switch(
                    value: session.isBackgroundMusicPlaying,
                    onChanged: (value) {
                      session.toggleBackgroundMusic();
                    },
                    activeColor: Color(0xFF8A3FFC),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(
                'Current Streak: ${session.streakCount} days',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

                    const SizedBox(height: 20),
                    _buildControlButton(context, session),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildControlButton(BuildContext context, SessionProvider session) {
    IconData icon;
    VoidCallback onPressed;

    if (session.sessionState == SessionState.finished) {
      icon = Icons.replay;
      onPressed = () => session.stopAndResetSession();
    } else if (session.isPlaying) {
      icon = Icons.pause;
      onPressed = () => session.pauseSession();
    } else {
      icon = Icons.play_arrow;
      onPressed = () => session.startOrResumeSession();
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: const Color(0xFF8A3FFC),
        foregroundColor: Colors.white,
      ),
      child: Icon(icon, size: 40),
    );
  }
}
