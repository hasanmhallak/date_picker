import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/date/days_view.dart';
import 'package:date_picker_plus/src/range/range_days_picker.dart';
import 'package:date_picker_plus/src/range/range_days_view.dart';
import 'package:date_picker_plus/src/shared/month_view.dart';
import 'package:date_picker_plus/src/shared/year_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme from context — defaults when constructor theme is omitted', () {
    testWidgets('DaysView uses default daysPickerTheme',
        (WidgetTester tester) async {
      late Color expected;
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .daysPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
                return DaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  onChanged: (_) {},
                  theme: DatePickerPlusTheme.of(context).daysPickerTheme!,
                  locale: DatePickerPlusTheme.of(context).locale!,
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

    testWidgets('MonthView uses default monthsPickerTheme',
        (WidgetTester tester) async {
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
                  theme: DatePickerPlusTheme.of(context).monthsPickerTheme!,
                  locale: DatePickerPlusTheme.of(context).locale!,
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

    testWidgets('YearView uses default yearsPickerTheme',
        (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2020, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .yearsPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
                return YearView(
                  currentDate: current,
                  minDate: DateTime(1950),
                  maxDate: DateTime(2060),
                  displayedYearRange:
                      DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
                  onChanged: (_) {},
                  theme: DatePickerPlusTheme.of(context).yearsPickerTheme!,
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

    testWidgets('DaysPicker passes default daysPickerTheme to DaysView',
        (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .daysPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
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

    testWidgets('MonthPicker passes default monthsPickerTheme to MonthView',
        (WidgetTester tester) async {
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

    testWidgets('YearsPicker passes default yearsPickerTheme to YearView',
        (WidgetTester tester) async {
      late Color expected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .yearsPickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
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

    testWidgets('RangeDaysView uses default rangePickerTheme',
        (WidgetTester tester) async {
      late Color expected;
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .rangePickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
                return RangeDaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  selectedStartDate: null,
                  selectedEndDate: null,
                  onStartDateChanged: (_) {},
                  onEndDateChanged: (_) {},
                  theme: DatePickerPlusTheme.of(context),
                  locale: DatePickerPlusTheme.of(context).locale!,
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

    testWidgets(
        'RangeDaysPicker passes default rangePickerTheme to RangeDaysView',
        (WidgetTester tester) async {
      late Color expected;
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) {
                expected = DatePickerPlusTheme.defaults(context)
                    .rangePickerTheme!
                    .resolveTextStyle(CellState.enabled)!
                    .color!;
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

  group(
      'Theme from context — ThemeData.extensions when constructor theme is omitted',
      () {
    const inheritedEnabledColor = Color(0xFFFF00FF);

    DatePickerPlusTheme inheritedTheme() => DatePickerPlusTheme(
          daysPickerTheme: DaysPickerTheme(
            enabledCellsTextStyle:
                const TextStyle(color: inheritedEnabledColor),
          ),
          monthsPickerTheme: MonthsPickerTheme(
            enabledCellsTextStyle:
                const TextStyle(color: inheritedEnabledColor),
          ),
          yearsPickerTheme: YearsPickerTheme(
            enabledCellsTextStyle:
                const TextStyle(color: inheritedEnabledColor),
          ),
          rangePickerTheme: RangePickerTheme(
            enabledCellsTextStyle:
                const TextStyle(color: inheritedEnabledColor),
          ),
        );

    testWidgets('DaysView uses daysPickerTheme from ThemeData.extensions',
        (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: Builder(
              builder: (context) {
                final t = DatePickerPlusTheme.of(context);
                return DaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  onChanged: (_) {},
                  theme: t.daysPickerTheme!,
                  locale: t.locale!,
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('MonthView uses monthsPickerTheme from ThemeData.extensions',
        (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: Builder(
              builder: (context) {
                final t = DatePickerPlusTheme.of(context);
                return MonthView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedDate: displayed,
                  onChanged: (_) {},
                  theme: t.monthsPickerTheme!,
                  locale: t.locale!,
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('YearView uses yearsPickerTheme from ThemeData.extensions',
        (WidgetTester tester) async {
      final current = DateTime(2020, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: Builder(
              builder: (context) {
                final t = DatePickerPlusTheme.of(context);
                return YearView(
                  currentDate: current,
                  minDate: DateTime(1950),
                  maxDate: DateTime(2060),
                  displayedYearRange:
                      DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
                  onChanged: (_) {},
                  theme: t.yearsPickerTheme!,
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('DaysPicker uses ThemeData.extensions into DaysView',
        (WidgetTester tester) async {
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('MonthPicker uses ThemeData.extensions into MonthView',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('YearsPicker uses ThemeData.extensions into YearView',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });
    testWidgets('DaysPicker theme overrides ThemeData.extensions into DaysView',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
              theme: inheritedTheme().copyWith(
                  daysPickerTheme: DaysPickerTheme(
                      disabledCellsTextStyle: TextStyle(color: disabledColor))),
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
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('MonthPicker theme overrides ThemeData.extensions into MonthView',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: MonthPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 11, 30),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: inheritedTheme().copyWith(
                  monthsPickerTheme: MonthsPickerTheme(
                      disabledCellsTextStyle: TextStyle(color: disabledColor))),
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
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('YearsPicker theme overrides ThemeData.extensions into YearsView',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: YearsPicker(
              minDate: DateTime(2000, 1, 1),
              maxDate: DateTime(2022, 11, 30),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: inheritedTheme().copyWith(
                  yearsPickerTheme: YearsPickerTheme(
                      disabledCellsTextStyle: TextStyle(color: disabledColor))),
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
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });
    testWidgets('DatePicker theme overrides ThemeData.extensions',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 1, 25),
              currentDate: DateTime(2022, 1, 1),
              displayedDate: DateTime(2022, 1, 1),
              theme: inheritedTheme().copyWith(
                  daysPickerTheme: DaysPickerTheme(
                      disabledCellsTextStyle: TextStyle(color: disabledColor))),
            ),
          ),
        ),
      );

      final enabledFinder = find.text('2');
      final disabledFinder = find.text('26');
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('RangeDaysView uses rangePickerTheme from ThemeData.extensions',
        (WidgetTester tester) async {
      final displayed = DateTime(2022, 6, 1);
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: Builder(
              builder: (context) {
                final t = DatePickerPlusTheme.of(context);
                return RangeDaysView(
                  currentDate: current,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  displayedMonth: displayed,
                  selectedStartDate: null,
                  selectedEndDate: null,
                  onStartDateChanged: (_) {},
                  onEndDateChanged: (_) {},
                  theme: t,
                  locale: t.locale!,
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('RangeDaysPicker uses ThemeData.extensions into RangeDaysView',
        (WidgetTester tester) async {
      final current = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets(
        'RangeDaysPicker theme overrides ThemeData.extensions into RangeDaysView',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 6, 14),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: inheritedTheme().copyWith(
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
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });

    testWidgets('RangeDatePicker uses ThemeData.extensions into RangeDaysView',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
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
      expect(
          tester.widget<Text>(textFinder).style?.color, inheritedEnabledColor);
    });

    testWidgets('RangeDatePicker theme overrides ThemeData.extensions',
        (WidgetTester tester) async {
      final disabledColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[inheritedTheme()],
          ),
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 6, 14),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              theme: inheritedTheme().copyWith(
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
      expect(tester.widget<Text>(enabledFinder).style?.color,
          inheritedEnabledColor);
      expect(tester.widget<Text>(disabledFinder).style?.color, disabledColor);
    });
  });

  group('isEnabled from context — RangeDaysPicker respects ThemeData.extensions',
      () {
    testWidgets(
        'RangeDaysPicker disables day taps when isEnabled=false is set via ThemeData.extensions only (no widget theme)',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[
              DatePickerPlusTheme(isEnabled: false),
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
          reason:
              'isEnabled=false from ThemeData.extensions should suppress taps in RangeDaysPicker');
    });

    testWidgets(
        'RangeDaysPicker remains interactive when isEnabled=true is set via ThemeData.extensions only',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[
              DatePickerPlusTheme(isEnabled: true),
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
          reason:
              'isEnabled=true from ThemeData.extensions should keep RangeDaysPicker interactive');
    });

    testWidgets(
        'RangeDaysPicker widget theme isEnabled=false overrides isEnabled=true from ThemeData.extensions',
        (WidgetTester tester) async {
      bool startDateChanged = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[
              DatePickerPlusTheme(isEnabled: true),
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
          reason:
              'widget theme isEnabled=false should override isEnabled=true from ThemeData.extensions');
    });
  });
}
