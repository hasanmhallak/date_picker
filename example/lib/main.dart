import 'package:date_picker_plus/date_picker_plus.dart';
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
      locale: const Locale('en'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('zh'),
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
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (selectedDate != null)
            //   Text(DateFormat(
            //     'MMM dd, yy',
            //   ).format(selectedDate!)),
            TextButton(
              onPressed: () async {
                showDatePicker(
                  context: context,
                  initialDate: DateTime(2022, 10, 1),
                  firstDate: DateTime(2022, 10, 1),
                  lastDate: DateTime(2023, 10, 30),
                );
              },
              child: const Text('Show Picker'),
            ),
            RangeDatePicker(
              maxDate: DateTime(2023, 10, 30),
              minDate: DateTime(2020, 10, 1),
              currentDate: DateTime(2023, 10, 5),
              onRangeSelected: (DateTimeRange value) {
                print(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
