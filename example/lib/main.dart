import 'package:datePicker/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en', 'US'),
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
      theme: ThemeData.light(useMaterial3: false),
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
    print(Localizations.localeOf(context).toString());
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
                Localizations.localeOf(context).languageCode,
              ).format(selectedDate!)),
            TextButton(
              onPressed: () async {
                final date = await showDatePickerDialog(
                  context: context,
                  initialPickerType: PickerType.years,
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
