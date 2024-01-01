import 'package:n_time/data/schedule_data.dart';
import 'package:n_time/data/event.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Schedule> loadSchedule(String username) async {
  late final Schedule schedule;
  try {
    schedule = await fetchSchedule(username);
    final events = await fetchEvents(schedule.scheduleId);
    debugPrint("Events: $events");
    for (Event event in events) {
      schedule.addEvent(event);
    }
  } on Exception catch (err) {
    debugPrint('Exception in loadSchedule: $err');
  }
  return schedule;
}

Future<List<Event>> fetchEvents(int scheduleId) async {
  const urlDomain = 'www.enginick.com:9696';
  final queryParams = {
    'schedule_id': scheduleId.toString(),
  };
  final response = await http.get(Uri.http(urlDomain, '/events', queryParams));
  if (response.statusCode == 200) {
    return compute(parseEvents, response.body);
  } else {
    throw Exception('Failed to fetch events');
  }
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