import 'package:flutter/material.dart';
import 'package:n_time/data/app_model.dart';
import 'package:n_time/logic/schedule_logic.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:n_time/ui/calendar.dart';
import 'package:get_it/get_it.dart';
import 'package:n_time/data/event.dart';

void main() async {
  registerSingletons();
  appModel.schedule = await loadSchedule(appModel.username);
  debugPrint(appModel.schedule?.scheduleName);
  runApp(const MyApp());
}

void registerSingletons() {
  GetIt.I.registerSingleton<AppModel>(AppModel());
}

AppModel get appModel => GetIt.I.get<AppModel>();

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
      body: const Calendar()
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
