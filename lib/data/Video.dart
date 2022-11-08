// To parse this JSON data, do
//
//     final Video = VideoFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Video videoFromJson(String str) => Video.fromJson(json.decode(str));

String videoToJson(Video data) => json.encode(data.toJson());

class Video {
  Video({
    this.title,
    this.duration,
    this.url,
    this.icon,
  });

  String? title;
  int? duration;
  String? url;
  String? icon;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        title: json["title"],
        duration: json["duration"],
        url: json["url"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "duration": duration,
        "url": url,
        "icon": icon,
      };
}
