import 'package:date_picker_plus/date_picker_plus.dart';
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
        child: RangeDatePicker(
          padding: EdgeInsets.zero,
          maxDate: DateTime(2023, 10, 30),
          minDate: DateTime(2023, 10, 10),
          currentDate: DateTime(2023, 10, 5),
          onRangeSelected: (DateTimeRange value) {
            debugPrint(value.toString());
          },
        ),
      ),
    );
  }
}
