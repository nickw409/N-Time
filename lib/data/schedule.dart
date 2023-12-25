import './event.dart';

class Schedule {
  List<Event> events = [];
  int scheduleId;
  String username;
  String scheduleName;

  Schedule(this.scheduleId, this.username, this.scheduleName);

  void addEvent(Event event) {
    events.add(event);
    events.sort();
  }

  void removeEvent(Event event) {
    events.remove(event);
    events.sort();
  }
}