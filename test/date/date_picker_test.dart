import 'package:date_picker_plus/src/date/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePicker', () {
    testWidgets(
      'Should clamp the initial date to fall between the max min range',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2023, 3, 11);
        final DateTime maxDate = DateTime(2024, 3, 20);

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
      },
    );

    testWidgets(
      'MonthPicker Should get the clamped initail date and not throw',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2023, 3, 11);
        final DateTime maxDate = DateTime(2024, 3, 20);

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

        final headerMonthFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'March 2024',
        );
        expect(headerMonthFinder, findsOneWidget);

        await tester.tap(headerMonthFinder);
        await tester.pumpAndSettle();

        final headerYearFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == '2024',
        );
        expect(headerYearFinder, findsOneWidget);

        await tester.tap(headerYearFinder);
        await tester.pumpAndSettle();

        final yearToSelectFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == '2023',
        );

        // should not throw after the tap.
        await tester.tap(yearToSelectFinder);
        await tester.pumpAndSettle();

        final monthToSelectFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Mar',
        );

        // should not throw after the tap.
        await tester.tap(monthToSelectFinder);
        await tester.pumpAndSettle();
      },
    );
  });
}
