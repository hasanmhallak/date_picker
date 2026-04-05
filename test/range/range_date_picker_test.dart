import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/range/range_days_picker.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeDatePicker', () {
    testWidgets(
      'should clamp the initial date if it falls outside of the valid range.',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2022, 1, 1);
        final DateTime maxDate = DateTime(2024, 1, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: RangeDatePicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        await tester.tap(find.byType(LeadingDate));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LeadingDate));
        await tester.pumpAndSettle();

        final yearToSelectFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == '2023',
        );

        await tester.tap(yearToSelectFinder);
        await tester.pumpAndSettle();

        final monthToSelectFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Mar',
        );

        await tester.tap(monthToSelectFinder);
        await tester.pumpAndSettle();
      },
    );

    testWidgets('should show MonthPicker when initialPickerType is months', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              initialPickerType: PickerType.months,
            ),
          ),
        ),
      );

      expect(find.byType(MonthPicker), findsOneWidget);
      expect(find.byType(RangeDaysPicker), findsNothing);
    });

    testWidgets('should show YearsPicker when initialPickerType is years', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              initialPickerType: PickerType.years,
            ),
          ),
        ),
      );

      expect(find.byType(YearsPicker), findsOneWidget);
      expect(find.byType(RangeDaysPicker), findsNothing);
    });

    testWidgets('should call onStartDateChanged on first tap', (WidgetTester tester) async {
      DateTime? startDate;
      final currentDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: currentDate,
              initialDate: currentDate,
              onStartDateChanged: (d) => startDate = d,
            ),
          ),
        ),
      );

      final target = find.byWidgetPredicate((widget) {
        if (widget is Semantics && widget.properties.label?.startsWith('5,') == true) return true;
        return false;
      });

      await tester.tap(target.first);
      await tester.pump();

      expect(startDate, isNotNull);
      expect(startDate!.day, equals(5));
    });

    testWidgets('should call onEndDateChanged on second tap and onRangeSelected with full range',
        (WidgetTester tester) async {
      DateTime? startDate;
      DateTime? endDate;
      DateTimeRange? range;
      final currentDate = DateTime(2022, 6, 1);

      Widget buildWidget(DateTime? start, DateTime? end) => MaterialApp(
            home: Material(
              child: RangeDatePicker(
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 12, 31),
                currentDate: currentDate,
                initialDate: currentDate,
                selectedRange: start != null && end != null ? DateTimeRange(start: start, end: end) : null,
                onStartDateChanged: (d) => startDate = d,
                onEndDateChanged: (d) => endDate = d,
                onRangeSelected: (r) => range = r,
              ),
            ),
          );

      await tester.pumpWidget(buildWidget(null, null));

      // Tap day 5 (start)
      final day5 = find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.label?.startsWith('5,') ?? false),
      );
      await tester.tap(day5.first);
      await tester.pump();
      expect(startDate!.day, equals(5));
      expect(endDate, isNull);

      await tester.pumpWidget(buildWidget(startDate, null));

      // Tap day 10 (end)
      final day10 = find.byWidgetPredicate(
        (w) => w is Semantics && (w.properties.label?.startsWith('10,') ?? false),
      );
      await tester.tap(day10.first);
      await tester.pump();

      expect(endDate!.day, equals(10));
      expect(range, isNotNull);
      expect(range!.start.day, equals(5));
      expect(range!.end.day, equals(10));
    });

    testWidgets('should call onLeadingDateTap when header is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              onLeadingDateTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should pre-select range when selectedRange is provided', (WidgetTester tester) async {
      final start = DateTime(2022, 6, 5);
      final end = DateTime(2022, 6, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              initialDate: DateTime(2022, 6, 1),
              selectedRange: DateTimeRange(start: start, end: end),
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  selectedCellsDecoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Cells within range should have the orange decoration
      final rangeCells = find.byWidgetPredicate((w) =>
          w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.orange);

      expect(rangeCells, findsWidgets);
    });

    testWidgets('should clear range highlights when selectedRange changes to null via didUpdateWidget',
        (WidgetTester tester) async {
      DateTimeRange? selectedRange = DateTimeRange(
        start: DateTime(2022, 6, 5),
        end: DateTime(2022, 6, 10),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatefulBuilder(
              builder: (ctx, setState) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => selectedRange = null),
                    child: const Text('clear'),
                  ),
                  RangeDatePicker(
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                    currentDate: DateTime(2022, 6, 1),
                    initialDate: DateTime(2022, 6, 1),
                    selectedRange: selectedRange,
                    theme: DatePickerPlusTheme(
                      rangePickerTheme: RangePickerTheme(
                        selectedCellsDecoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.orange),
        findsWidgets,
      );

      await tester.tap(find.text('clear'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.orange),
        findsNothing,
      );
    });

    testWidgets('should navigate days → months → years → months → days', (WidgetTester tester) async {
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              currentDate: initialDate,
              initialDate: initialDate,
            ),
          ),
        ),
      );

      // Days → Months
      await tester.tap(find.byType(LeadingDate));
      await tester.pumpAndSettle();
      expect(find.byType(MonthPicker), findsOneWidget);

      // Months → Years
      await tester.tap(find.byType(LeadingDate));
      await tester.pumpAndSettle();
      expect(find.byType(YearsPicker), findsOneWidget);

      await tester.tap(find.text('2022'));
      await tester.pumpAndSettle();
      expect(find.byType(MonthPicker), findsOneWidget);

      await tester.tap(find.text('Mar'));
      await tester.pumpAndSettle();
      expect(find.byType(RangeDaysPicker), findsOneWidget);
    });

    testWidgets('should apply custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(40);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              padding: customPadding,
            ),
          ),
        ),
      );

      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final hasPadding = paddingWidgets.any((p) => p.padding == customPadding);
      expect(hasPadding, isTrue);
    });

    testWidgets('should throw assertion error when minDate is after maxDate', (WidgetTester tester) async {
      expect(
        () => RangeDatePicker(
          minDate: DateTime(2025, 1, 1),
          maxDate: DateTime(2020, 1, 1),
        ),
        throwsAssertionError,
      );
    });
  });
}
