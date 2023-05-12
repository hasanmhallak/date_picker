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
      locale: Locale('en'),
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
                initialDate: DateTime.now().add(Duration(days: 30 * 2)),
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

  @override
  void initState() {
    _displayedMonth = widget.initialDate;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SwiftDatePicker oldWidget) {
    if (widget.initialDate != oldWidget.initialDate) {
      _displayedMonth = widget.initialDate;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Header(),
        const SizedBox(height: 10),
        DaysView(
          currentDate: DateTime.now(),
          minDate: DateTime.now().subtract(const Duration(days: 365)),
          maxDate: DateTime.now().add(const Duration(days: 90)),
          displayedMonth: _displayedMonth!,
          selectedDate: _selectedDate,
          onChanged: (value) {
            setState(() {
              _selectedDate = value;
            });
          },
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _Year(),
        const _MonthsSlider(),
      ],
    );
  }
}

class _MonthsSlider extends StatelessWidget {
  final VoidCallback? onForward;
  final VoidCallback? onBackward;
  final Color? color;
  const _MonthsSlider({
    Key? key,
    this.onForward,
    this.onBackward,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onBackward,
            child: SizedBox(
              width: 36,
              height: 36,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 654)),
                lastDate: DateTime.now().add(Duration(days: 654)),
              );
            },
            child: SizedBox(
              width: 36,
              height: 36,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 28,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Year extends StatefulWidget {
  final DateTime? date;
  final TextStyle? yearTextStyle;
  final Color? focusedColor;
  final Color? unFocusedColor;
  final VoidCallback? onTap;
  const _Year({
    super.key,
    this.date,
    this.focusedColor,
    this.unFocusedColor,
    this.yearTextStyle,
    this.onTap,
  });

  @override
  State<_Year> createState() => _YearState();
}

class _YearState extends State<_Year> with SingleTickerProviderStateMixin {
  late final AnimationController arrowController;
  late final Animation<double> arrowAnimation;

  DateTime? _dateTime;
  TextStyle? _yearTextStyle;
  Color? _focusedColor;
  Color? _unFocusedColor;

  @override
  void initState() {
    arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    arrowAnimation = CurvedAnimation(
      parent: arrowController,
      curve: Curves.ease,
    ).drive(Tween<double>(begin: 0.0, end: 0.25));
    //
    _dateTime ??= DateTime.now();
    _yearTextStyle ??=
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant _Year oldWidget) {
    if (oldWidget.date != widget.date) {
      _dateTime = widget.date;
    }
    if (oldWidget.yearTextStyle != widget.yearTextStyle) {
      _yearTextStyle = widget.yearTextStyle;
    }

    if (oldWidget.focusedColor != widget.focusedColor) {
      _focusedColor = widget.focusedColor;
    }

    if (oldWidget.unFocusedColor != widget.unFocusedColor) {
      _unFocusedColor = widget.unFocusedColor;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusedColor ??= Theme.of(context).colorScheme.primary;
    _unFocusedColor ??= Theme.of(context).colorScheme.onBackground;
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        if (arrowController.isDismissed) {
          arrowController.forward();
        } else {
          arrowController.reverse();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            MaterialLocalizations.of(context).formatMonthYear(_dateTime!),
            style: _yearTextStyle,
          ),
          const SizedBox(width: 2),
          AnimatedBuilder(
            animation: arrowAnimation,
            builder: (context, child) {
              return RotationTransition(
                turns: arrowAnimation,
                child: child,
              );
            },
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: _focusedColor,
            ),
          ),
        ],
      ),
    );
  }
}
