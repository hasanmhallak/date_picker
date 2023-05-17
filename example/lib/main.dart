import 'package:datePicker/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en', 'GB'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('en', 'GB'),
        Locale('ar'),
        Locale('fa'),
      ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 120),
            TextButton(
              onPressed: () async {
                final date = await showDatePickerDialog(context);
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: const Text('Show Picker'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                child: DatePicker(
                  initialDate: DateTime.now(),
                  maxDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  minDate:
                      DateTime.now().subtract(const Duration(days: 365 * 3)),
                  onDateChanged: (value) {
                    // Navigator.pop(context, value);
                    print(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38),
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: DatePicker(
            initialDate: DateTime.now(),
            maxDate: DateTime.now().add(const Duration(days: 365 * 3)),
            minDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
            onDateChanged: (value) {
              Navigator.pop(context, value);
            },
          ),
        ),
      );
    },
  );
}
