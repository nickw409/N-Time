import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './event.dart';

class Schedule {
  List<Event> events = [];
  int scheduleId;
  String username;
  String scheduleName;

  Schedule({
    required this.scheduleId, 
    required this.username, 
    required this.scheduleName
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'sched_id': int scheduleId,
        'username': String username,
        'schedule_name': String scheduleName,
      } =>
        Schedule(
          scheduleId: scheduleId, 
          username: username, 
          scheduleName: scheduleName
        ),
      _ => throw const FormatException('Failed to fetch scheduls'),
    };
  }
  
  void addEvent(Event event) {
    events.add(event);
    events.sort();
  }

  void removeEvent(Event event) {
    events.remove(event);
    events.sort();
  }

  
}

Future<List<Event>> fetchEvents(int scheduleId) async {
  const urlDomain = 'www.enginick.com:9696';
  final queryParams = {
    'schedule_id': scheduleId,
  };

  final response = await http.get(Uri.http(urlDomain, '/events', queryParams));
  if (response.statusCode == 200) {
    return compute(parseEvents, response.body);
  } else {
    throw Exception('Failed to fetch events');
  }
}

List<Event> parseEvents(String body) {
  final parsed = (jsonDecode(body) as List).cast<Map<String, dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
} 

Future<Schedule> fetchSchedule(String username) async {
  const urlDomain = 'www.enginick.com:9696';
  final queryParams = {
    'username': username,
  };

  final response = await http.get(Uri.http(urlDomain, '/schedules', queryParams));
  if (response.statusCode == 200) {
    var decoded = jsonDecode(response.body);
    return Schedule.fromJson(decoded[0] as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load schedules');
  }
}