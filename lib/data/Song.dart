// To parse this JSON data, do
//
//     final song = songFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Song songFromJson(String str) => Song.fromJson(json.decode(str));

String songToJson(Song data) => json.encode(data.toJson());

class Song {
  Song({
    this.artist,
    this.title,
    this.duration,
    this.url,
    this.icon,
  });

  String? artist;
  String? title;
  int? duration;
  String? url;
  String? icon;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        artist: json["artist"],
        title: json["title"],
        duration: json["duration"],
        url: json["url"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "artist": artist,
        "title": title,
        "duration": duration,
        "url": url,
        "icon": icon,
      };
}
