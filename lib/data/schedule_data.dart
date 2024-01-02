import 'package:n_time/data/event_data.dart';

class Schedule {
  List<Event> events = [];
  final int scheduleId;
  final String username;
  final String scheduleName;

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
