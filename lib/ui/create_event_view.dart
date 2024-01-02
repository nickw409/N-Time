import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  EventFormState createState() {
    return EventFormState();
  }
}

class EventFormState extends State<EventForm> {
  final _eventFormKey = GlobalKey<FormState>();
  
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();
  final DateFormat formatter = DateFormat('MMM d, y');

  TimeOfDay? _startTime = TimeOfDay.now();
  TimeOfDay? _endTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 5)));

  @override 
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
      color:  Theme.of(context).colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'New Event',
          style: headerStyle,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_eventFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Good Input')),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Save',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              ),
          ),
        ],
      ),
      body: Form(
        key: _eventFormKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Starts',
                          textAlign: TextAlign.left,
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          child: Text(formatter.format(_startDate!)),
                          onPressed: () async {
                            final DateTime? startDate = await showDatePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                              currentDate: DateTime.now(),
                              firstDate: DateTime(1998), 
                              lastDate: DateTime(2040),
                            );
                            setState(() {
                              if (startDate != null) {
                                _startDate = startDate;
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          child: Text(
                            '${_startTime?.hour.toString().padLeft(2, '0')}'
                            ':'
                            '${_startTime?.minute.toString().padLeft(2, '0')}'
                            ),
                          onPressed: () async {
                            final TimeOfDay? startTime = await showTimePicker(
                              context: context,
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              initialTime: _startTime ?? TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              }
                            );
                            setState(() {
                              if (startTime != null) {
                                _startTime = startTime;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          'Ends',
                          textAlign: TextAlign.left,
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          child: Text(formatter.format(_endDate!)),
                          onPressed: () async {
                            final DateTime? endDate = await showDatePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                              currentDate: DateTime.now(),
                              firstDate: DateTime(1998), 
                              lastDate: DateTime(2040),
                            );
                            setState(() {
                              if (endDate != null) {
                                _endDate = endDate;
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          child: Text(
                            '${_endTime?.hour.toString().padLeft(2, '0')}'
                            ':'
                            '${_endTime?.minute.toString().padLeft(2, '0')}'
                            ),
                          onPressed: () async {
                            final TimeOfDay? endTime = await showTimePicker(
                              context: context,
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              initialTime: _endTime ?? TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              }
                            );
                            setState(() {
                              if (endTime != null) {
                                _endTime = endTime;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}