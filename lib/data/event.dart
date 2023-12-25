class Event implements Comparable<Event>{
  int id;
  String title;
  DateTime dateTime;
  int duration;

  Event(this.id, this.title, this.dateTime, this.duration);

  @override
  bool operator ==(Object other) {
    if (other is Event) {
      if (dateTime.compareTo(other.dateTime) == 0) {
        return true;
      }
    }
    return false;
  }

  @override
  int compareTo(Event other) {
    return dateTime.compareTo(other.dateTime);
  }
}