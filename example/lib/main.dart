import 'package:datePicker/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedDate != null)
              Text(DateFormat(
                'MMM dd, yy',
              ).format(selectedDate!)),
            TextButton(
              onPressed: () async {
                final date = await showDatePickerDialog(
                  context: context,
                  initialDate: DateTime.now(),
                  maxDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  minDate:
                      DateTime.now().subtract(const Duration(days: 365 * 3)),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: const Text('Show Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
