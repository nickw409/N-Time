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

Future<Schedule> fetchSchedule(String username) async {
  String urlDomain = 'http://www.enginick.com:9696';

  final response = await http.get(Uri.parse('$urlDomain/schedules/$username'));

  if (response.statusCode == 200) {
    return Schedule.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load schedules');
  }
}