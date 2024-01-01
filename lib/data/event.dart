import 'dart:convert';
import 'package:flutter/foundation.dart';
class Event implements Comparable<Event>{
  int id;
  String title;
  DateTime dateTime;
  int duration;

  Event({
    required this.id, 
    required this.title, 
    required this.dateTime, 
    required this.duration
    });

  factory Event.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'dateAndTime': String dateAndTime,
        'duration': int duration,
      } =>
        Event(
          id: id,
          title: title,
          dateTime: DateTime.parse(dateAndTime),
          duration: duration,
        ),
      _ => throw const FormatException('Failed to convert event from json'),
    };
  }

  @override
  int compareTo(Event other) {
    return dateTime.compareTo(other.dateTime);
  }
}

List<Event> parseEvents(String body) {
  final parsed = (jsonDecode(body) as List).cast<Map<String, dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}