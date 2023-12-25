import 'package:flutter/material.dart';
import 'package:n_time/data/event.dart';
import 'package:n_time/data/schedule.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'N-Time',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'N-Time'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var status = false;
  Schedule schedule = Schedule(
    scheduleId : 1, 
    username : 'admin', 
    scheduleName : 'testing'
  );

  void getStatus() async {
    final response = await http.get(
                            Uri.parse('http://www.enginick.com:9696/status'));
    
    if (response.statusCode == 200) {
      status = true;
    } else {
      status = false;
    }
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Schedule> schedule;
  String username = 'admin';

  @override
  void initState() {
    super.initState();
    schedule = fetchSchedule(username);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: style,
        ),
      ),
      body: const Column(
        children: [
          Center(
            child: Calendar(),
          ),
          SizedBox(height: 20,),
          Center(
            child: ServerStatus(),
          ),
        ],
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Event> _getEventsForDay(DateTime day) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 1, 1),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) {
        return _getEventsForDay(day);
      },
    );
  }
}

class ServerStatus extends StatelessWidget {
  const ServerStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var status = appState.status;

    appState.getStatus();

    return Text("$status");
  }
}
