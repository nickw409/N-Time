import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:n_time/data/event.dart';
import 'package:n_time/data/schedule.dart';
import 'package:n_time/ui/calendar.dart';

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
  late Schedule schedule;

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
  late Future<List<Event>> events;
  String username = 'admin';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var appState = context.watch<MyAppState>();
    schedule.then((schedule) => appState.schedule = schedule);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: style,
        ),
      ),
      body: Column(
        children: [
          const Center(
            child: Calendar(),
          ),
          const SizedBox(height: 20,),
          Center(
            child: FutureBuilder<Schedule>(
              future: schedule, 
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.scheduleName);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            )
          ),
        ],
      ),
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
