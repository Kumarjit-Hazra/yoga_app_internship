import 'dart:convert';


YogaSession yogaSessionFromJson(String str) =>
    YogaSession.fromJson(json.decode(str));


class YogaSession {
  final Metadata metadata;
  final Assets assets;
  final List<SequenceItem> sequence;

  YogaSession({
    required this.metadata,
    required this.assets,
    required this.sequence,
  });

 
  factory YogaSession.fromJson(Map<String, dynamic> json) => YogaSession(
        metadata: Metadata.fromJson(json["metadata"]),
        assets: Assets.fromJson(json["assets"]),
        sequence: List<SequenceItem>.from(
            json["sequence"].map((x) => SequenceItem.fromJson(x))),
      );
}


class Assets {
  final Map<String, String> images;
  final Map<String, String> audio;

  Assets({
    required this.images,
    required this.audio,
  });

  
  factory Assets.fromJson(Map<String, dynamic> json) => Assets(
        images: Map.from(json["images"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        audio: Map.from(json["audio"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );
}


class Metadata {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  Metadata({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
  });

  
  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        id: json["id"],
        title: json["title"],
        category: json["category"],
        defaultLoopCount: json["defaultLoopCount"],
        tempo: json["tempo"],
      );
}


class SequenceItem {
  final String type;
  final String name;
  final String audioRef;
  final int durationSec;
  final List<ScriptItem> script;
  final String? iterations; 
  final bool? loopable;

  SequenceItem({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    required this.script,
    this.iterations,
    this.loopable,
  });


  factory SequenceItem.fromJson(Map<String, dynamic> json) => SequenceItem(
        type: json["type"],
        name: json["name"],
        audioRef: json["audioRef"],
        durationSec: json["durationSec"],
        script: List<ScriptItem>.from(
            json["script"].map((x) => ScriptItem.fromJson(x))),
        iterations: json["iterations"], 
        loopable: json["loopable"],
      );
}


class ScriptItem {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  ScriptItem({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });

  
  factory ScriptItem.fromJson(Map<String, dynamic> json) => ScriptItem(
        text: json["text"],
        startSec: json["startSec"],
        endSec: json["endSec"],
        imageRef: json["imageRef"],
      );
}
