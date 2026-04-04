import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePicker', () {
    testWidgets(
      'should clamp the initial date if it falls outside of the valid range.',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2022, 1, 1);
        final DateTime maxDate = DateTime(2023, 1, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DatePicker(
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
            child: DatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              initialPickerType: PickerType.months,
            ),
          ),
        ),
      );

      expect(find.byType(MonthPicker), findsOneWidget);
      expect(find.byType(DaysPicker), findsNothing);
    });

    testWidgets('should show YearsPicker when initialPickerType is years', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              initialPickerType: PickerType.years,
            ),
          ),
        ),
      );

      expect(find.byType(YearsPicker), findsOneWidget);
      expect(find.byType(DaysPicker), findsNothing);
    });

    testWidgets('should call onDateSelected with the correct date when a day is tapped', (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: initialDate,
              initialDate: initialDate,
              onDateSelected: (date) => result = date,
            ),
          ),
        ),
      );

      final dayFinder = find.byWidgetPredicate((widget) {
        if (widget is Semantics && widget.properties.label?.startsWith('10,') == true) {
          return true;
        }
        return false;
      });

      await tester.tap(dayFinder.first);
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.day, equals(10));
      expect(result!.month, equals(6));
      expect(result!.year, equals(2022));
    });

    testWidgets('should pre-select a day when selectedDate is provided', (WidgetTester tester) async {
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: initialDate,
              initialDate: initialDate,
              selectedDate: DateTime(2022, 6, 15),
              theme: DatePickerPlusTheme(
                daysPickerTheme: DaysPickerTheme(
                  selectedCellDecoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final selectedCell = find.byWidgetPredicate((w) =>
          w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.purple);

      expect(selectedCell, findsOneWidget);
    });

    testWidgets('should not call onDateSelected when a predicate-disabled day is tapped', (WidgetTester tester) async {
      bool called = false;
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: initialDate,
              initialDate: initialDate,
              disabledDayPredicate: (d) => d.day == 10,
              onDateSelected: (_) => called = true,
            ),
          ),
        ),
      );

      final disabledDay = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics) {
          Widget? inner = widget.child;
          if (inner is Padding) inner = inner.child;
          if (inner is Container && inner.child is Center) {
            final text = (inner.child as Center).child;
            if (text is Text && text.data == '10') return true;
          }
        }
        return false;
      });

      expect(disabledDay, findsOneWidget);
      await tester.tap(disabledDay, warnIfMissed: false);
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('should not navigate or select when theme isEnabled is false', (WidgetTester tester) async {
      DateTime? result;
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: initialDate,
              initialDate: initialDate,
              theme: const DatePickerPlusTheme(isEnabled: false),
              onDateSelected: (d) => result = d,
            ),
          ),
        ),
      );

      expect(find.byType(DaysPicker), findsOneWidget);

      await tester.tap(find.byType(LeadingDate));
      await tester.pumpAndSettle();
      expect(find.byType(MonthPicker), findsNothing);

      final Finder dayFinder = find.byWidgetPredicate((widget) {
        if (widget is Semantics && widget.properties.label?.startsWith('15,') == true) {
          return true;
        }
        return false;
      });
      await tester.tap(dayFinder.first);
      await tester.pump();

      expect(result, isNull);
    });

    testWidgets('should navigate days → months → years → months → days', (WidgetTester tester) async {
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
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
      expect(find.byType(DaysPicker), findsOneWidget);

      final header = find.byType(LeadingDate);
      final headerText = tester.widget<Text>(find.descendant(of: header, matching: find.byType(Text))).data;
      expect(headerText, contains('March'));
    });

    testWidgets('should apply custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(32);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DatePicker(
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
        () => DatePicker(
          minDate: DateTime(2025, 1, 1),
          maxDate: DateTime(2020, 1, 1),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('should update selectedDate highlight via didUpdateWidget', (WidgetTester tester) async {
      DateTime? selectedDate;
      final initialDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => selectedDate = DateTime(2022, 6, 10)),
                      child: const Text('select'),
                    ),
                    DatePicker(
                      minDate: DateTime(2022, 1, 1),
                      maxDate: DateTime(2022, 12, 31),
                      currentDate: initialDate,
                      initialDate: initialDate,
                      selectedDate: selectedDate,
                      theme: DatePickerPlusTheme(
                        daysPickerTheme: DaysPickerTheme(
                          selectedCellDecoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((w) =>
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.purple),
        findsNothing,
      );

      await tester.tap(find.text('select'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.purple),
        findsOneWidget,
      );
    });
  });
}
