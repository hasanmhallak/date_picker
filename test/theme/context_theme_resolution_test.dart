import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/date/days_view.dart';
import 'package:date_picker_plus/src/range/range_days_picker.dart';
import 'package:date_picker_plus/src/range/range_days_view.dart';
import 'package:date_picker_plus/src/shared/month_view.dart';
import 'package:date_picker_plus/src/shared/year_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme from context — defaults when constructor theme is omitted', () {
    testWidgets('DaysView uses default daysPickerTheme', (WidgetTester tester) async {
      late Color expected;
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).daysPickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return DaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  onChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('MonthView uses default monthsPickerTheme', (WidgetTester tester) async {
      late Color expected;
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .monthsPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
                return MonthView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedDate: displayed,
                  onChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Mar'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('YearView uses default yearsPickerTheme', (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2020, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).yearsPickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return YearView(
                  currentDate: current,
                  minDate: DateTime(1950),
                  maxDate: DateTime(2060),
                  displayedYearRange: DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
                  onChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2022'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('DaysPicker passes default daysPickerTheme to DaysView', (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).daysPickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return DaysPicker(
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  currentDate: current,
                  displayedDate: current,
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('MonthPicker passes default monthsPickerTheme to MonthView', (WidgetTester tester) async {
      late Color expected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .monthsPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
                return MonthPicker(
                  minDate: DateTime(2020, 1, 1),
                  maxDate: DateTime(2025, 12, 31),
                  displayedDate: DateTime(2022, 6, 1),
                  currentDate: DateTime(2022, 6, 1),
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Mar'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('YearsPicker passes default yearsPickerTheme to YearView', (WidgetTester tester) async {
      late Color expected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).yearsPickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return YearsPicker(
                  minDate: DateTime(2010, 1, 1),
                  maxDate: DateTime(2030, 12, 31),
                  currentDate: DateTime(2020, 1, 1),
                  displayedDate: DateTime(2020, 1, 1),
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2015'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('RangeDaysView uses default rangePickerTheme', (WidgetTester tester) async {
      late Color expected;
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).rangePickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return RangeDaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  selectedStartDate: null,
                  selectedEndDate: null,
                  onStartDateChanged: (_) {},
                  onEndDateChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });

    testWidgets('RangeDaysPicker passes default rangePickerTheme to RangeDaysView', (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected =
                    DatePickerPlusTheme.defaults(context).rangePickerTheme!.resolveTextStyle(CellState.enabled)!.color!;
                return RangeDaysPicker(
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  currentDate: current,
                  displayedDate: current,
                );
              },
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, expected);
    });
  });

  group('Theme from context — ThemeData extension when constructor theme is omitted', () {
    const extensionEnabledColor = Color(0xFFFF00FF);

    DatePickerPlusTheme extensionTheme() => DatePickerPlusTheme(
          daysPickerTheme: DaysPickerTheme(
            enabledCellsTextStyle: const TextStyle(color: extensionEnabledColor),
          ),
          monthsPickerTheme: MonthsPickerTheme(
            enabledCellsTextStyle: const TextStyle(color: extensionEnabledColor),
          ),
          yearsPickerTheme: YearsPickerTheme(
            enabledCellsTextStyle: const TextStyle(color: extensionEnabledColor),
          ),
          rangePickerTheme: RangePickerTheme(
            enabledCellsTextStyle: const TextStyle(color: extensionEnabledColor),
          ),
        );

    testWidgets('DaysView uses daysPickerTheme from Theme extension', (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: DaysView(
              currentDate: current,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              displayedMonth: displayed,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('MonthView uses monthsPickerTheme from Theme extension', (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: MonthView(
              currentDate: current,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              displayedDate: displayed,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Mar'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('YearView uses yearsPickerTheme from Theme extension', (WidgetTester tester) async {
      final current = DateTime(2020, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: YearView(
              currentDate: current,
              minDate: DateTime(1950),
              maxDate: DateTime(2060),
              displayedYearRange: DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2022'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('DaysPicker uses Theme extension into DaysView', (WidgetTester tester) async {
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: DaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: current,
              displayedDate: current,
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('MonthPicker uses Theme extension into MonthView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: MonthPicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              displayedDate: DateTime(2022, 6, 1),
              currentDate: DateTime(2022, 6, 1),
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Mar'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('YearsPicker uses Theme extension into YearView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: YearsPicker(
              minDate: DateTime(2010, 1, 1),
              maxDate: DateTime(2030, 12, 31),
              currentDate: DateTime(2020, 1, 1),
              displayedDate: DateTime(2020, 1, 1),
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2015'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });
    testWidgets('DaysPicker theme overrides Theme extension into DaysView', (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: DaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              disabledDayPredicate: (date) {
                if (date == DateTime(2022, 6, 2)) return true;
                return false;
              },
              theme: extensionTheme()
                  .copyWith(daysPickerTheme: DaysPickerTheme(disabledCellsTextStyle: TextStyle(color: disabledColor))),
            ),
          ),
        ),
      );

      final enabledFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('10'),
      );
      final disabledFinder = find.descendant(
        of: find.byType(DaysView),
        matching: find.text('2'),
      );
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('MonthPicker theme overrides Theme extension into MonthView', (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: MonthPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 11, 30),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: extensionTheme().copyWith(
                  monthsPickerTheme: MonthsPickerTheme(disabledCellsTextStyle: TextStyle(color: disabledColor))),
            ),
          ),
        ),
      );

      final enabledFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Mar'),
      );
      final disabledFinder = find.descendant(
        of: find.byType(MonthView),
        matching: find.text('Dec'),
      );
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('YearsPicker theme overrides Theme extension into YearsView', (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: YearsPicker(
              minDate: DateTime(2000, 1, 1),
              maxDate: DateTime(2022, 11, 30),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: extensionTheme().copyWith(
                  yearsPickerTheme: YearsPickerTheme(disabledCellsTextStyle: TextStyle(color: disabledColor))),
            ),
          ),
        ),
      );

      final enabledFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2013'),
      );
      final disabledFinder = find.descendant(
        of: find.byType(YearView),
        matching: find.text('2023'),
      );
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });
    testWidgets('DatePicker theme overrides Theme extension', (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 1, 25),
              currentDate: DateTime(2022, 1, 1),
              displayedDate: DateTime(2022, 1, 1),
              theme: extensionTheme()
                  .copyWith(daysPickerTheme: DaysPickerTheme(disabledCellsTextStyle: TextStyle(color: disabledColor))),
            ),
          ),
        ),
      );

      final enabledFinder = find.text('2');
      final disabledFinder = find.text('26');
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('RangeDaysView uses rangePickerTheme from Theme extension', (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: RangeDaysView(
              currentDate: current,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              displayedMonth: displayed,
              selectedStartDate: null,
              selectedEndDate: null,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('RangeDaysPicker uses Theme extension into RangeDaysView', (WidgetTester tester) async {
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: current,
              displayedDate: current,
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('RangeDaysPicker theme overrides Theme extension into RangeDaysView', (WidgetTester tester) async {
      final disabledColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 6, 14),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: extensionTheme().copyWith(
                rangePickerTheme: RangePickerTheme(
                  disabledCellsTextStyle: TextStyle(color: disabledColor),
                ),
              ),
            ),
          ),
        ),
      );

      // Day 10 is enabled, day 16 is beyond maxDate and disabled.
      final enabledFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      final disabledFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('16'),
      );
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('RangeDatePicker uses Theme extension into RangeDaysView', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
            ),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      expect(tester.widget<Text>(textFinder).style?.color, extensionEnabledColor);
    });

    testWidgets('RangeDatePicker theme overrides Theme extension', (WidgetTester tester) async {
      final disabledColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[extensionTheme()],
          ),
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 6, 14),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: extensionTheme().copyWith(
                rangePickerTheme: RangePickerTheme(
                  disabledCellsTextStyle: TextStyle(color: disabledColor),
                ),
              ),
            ),
          ),
        ),
      );

      final enabledFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('10'),
      );
      final disabledFinder = find.descendant(
        of: find.byType(RangeDaysView),
        matching: find.text('16'),
      );
      expect(tester.widget<Text>(enabledFinder).style?.color, extensionEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });
  });

  group('isEnabled from context — RangeDaysPicker respects Theme extension', () {
    testWidgets(
        'RangeDaysPicker disables day taps when isEnabled=false is set via Theme extension only (no widget theme)',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[
              const DatePickerPlusTheme(isEnabled: false),
            ],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              onStartDateChanged: (_) {
                startDateChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();

      expect(startDateChanged, isFalse,
          reason: 'isEnabled=false from Theme extension should suppress taps in RangeDaysPicker');
    });

    testWidgets('RangeDaysPicker remains interactive when isEnabled=true is set via Theme extension only',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[
              const DatePickerPlusTheme(isEnabled: true),
            ],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              onStartDateChanged: (_) {
                startDateChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();

      expect(startDateChanged, isTrue,
          reason: 'isEnabled=true from Theme extension should keep RangeDaysPicker interactive');
    });

    testWidgets('RangeDaysPicker widget theme isEnabled=false overrides isEnabled=true from Theme extension',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[
              const DatePickerPlusTheme(isEnabled: true),
            ],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: const DatePickerPlusTheme(isEnabled: false),
              onStartDateChanged: (_) {
                startDateChanged = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('10'));
      await tester.pump();

      expect(startDateChanged, isFalse,
          reason: 'widget theme isEnabled=false should override isEnabled=true from Theme extension');
    });
  });
}
