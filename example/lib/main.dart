import 'package:datePicker/date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en', 'GB'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('en', 'GB'),
        Locale('ar'),
        Locale('fa'),
      ],
      // theme: ThemeData(colorScheme: ColorScheme.light()),
      theme: ThemeData.light(useMaterial3: true),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.scrolledUnder)) {
              return Colors.red;
            } else {
              return Colors.black;
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Dialog(
            elevation: 90,
            insetPadding: EdgeInsets.zero,

            /// Applies a surface tint color to a given container color to indicate
            /// the level of its elevation.
            /// from [backgroundColor] & [surfaceTint].
            /// check [ElevationOverlay] for more details.
            backgroundColor: Colors.white,
            child: Container(
              // height: 300,
              // width: double.infinity,
              padding: const EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: SwiftDatePicker(
                initialDate: DateTime.now(),
                maxDate: DateTime.now().add(const Duration(days: 365)),
                minDate: DateTime.now().subtract(const Duration(days: 365)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwiftDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime maxDate;
  final DateTime minDate;
  const SwiftDatePicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
  });

  @override
  State<SwiftDatePicker> createState() => _SwiftDatePickerState();
}

class _SwiftDatePickerState extends State<SwiftDatePicker> {
  DateTime? _displayedMonth;
  DateTime? _selectedDate;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;
  double maxHeight = 52 * 6; // A 31 day month that starts on Saturday.

  @override
  void initState() {
    _displayedMonth = widget.initialDate;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, widget.initialDate),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SwiftDatePicker oldWidget) {
    // there is no need to check for the displayed month because it changes via
    // page view and not the initial date.
    // but for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (DateUtils.dateOnly(oldWidget.initialDate) !=
        DateUtils.dateOnly(widget.initialDate)) {
      _pageController.jumpToPage(
        DateUtils.monthDelta(widget.minDate, widget.initialDate),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.minDate, index);

    return DaysView(
      key: ValueKey<DateTime>(month),
      currentDate: DateTime.now(),
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedMonth: month,
      selectedDate: _selectedDate,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
      },
    );
  }

  void _handleMonthPageChanged(int monthPage) {
    final DateTime monthDate =
        DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);

    setState(() {
      _displayedMonth = monthDate;
      if (isSevenRows(monthDate.year, monthDate.month, monthDate.weekday)) {
        maxHeight = 52 * 7;
      } else {
        maxHeight = 52 * 6;
      }
    });
  }

  bool isSevenRows(int year, int month, int weekday) {
    if (DateUtils.getDaysInMonth(year, month) == 31 &&
        weekday == DateTime.saturday) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(
          onLeadingTap: () {},
          displayedMonth: _displayedMonth!,
          onNextMonth: () {},
          onPreviousMonth: () {},
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: maxHeight,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            key: _pageViewKey,
            controller: _pageController,
            itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
            itemBuilder: _buildItems,
            onPageChanged: _handleMonthPageChanged,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onLeadingTap;
  final VoidCallback onNextMonth;
  final VoidCallback onPreviousMonth;
  const _Header({
    super.key,
    required this.displayedMonth,
    required this.onLeadingTap,
    required this.onNextMonth,
    required this.onPreviousMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LeadingDate(
          onTap: onLeadingTap,
          displayedText:
              MaterialLocalizations.of(context).formatMonthYear(displayedMonth),
        ),
        PageSliders(
          onBackward: onPreviousMonth,
          onForward: onNextMonth,
        ),
      ],
    );
  }
}
