import 'package:date_picker_plus/src/shared/year_view.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearView', () {
    testWidgets('should have no selected year when selected year is null', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(currentDate.year - 50, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 50, currentDate.month, currentDate.day),
              displayedYearRange: DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
            ),
          ),
        ),
      );

      final Finder selectedDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border == null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsNothing);
    });

    testWidgets('should highlight this year only.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(1950),
              maxDate: DateTime(2060),
              displayedYearRange: DateTimeRange(start: DateTime(2019), end: DateTime(2030)),
              theme: YearsPickerTheme(
                currentDateDecoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  shape: BoxShape.circle,
                ),
                enabledCellsDecoration: const BoxDecoration(),
                selectedCellDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
              ),
            ),
          ),
        ),
      );

      final Finder thisMonthFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(thisMonthFinder, findsOneWidget);
    });

    testWidgets('should be two widget highlighted, this year with border, and selected year with fill color.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 2, 1);
      final DateTime selectedMonth = DateTime(2021, 3, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(2019),
              maxDate: DateTime(2030),
              displayedYearRange: DateTimeRange(start: DateTime(2020), end: DateTime(2031)),
              selectedDate: selectedMonth,
              theme: YearsPickerTheme(
                currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                selectedCellDecoration: const BoxDecoration(shape: BoxShape.circle),
                enabledCellsDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
              ),
            ),
          ),
        ),
      );

      final Finder selectedDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border == null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsOneWidget);
      expect(todayFinder, findsOneWidget);
    });

    testWidgets('should be one widget highlighted, when selected year is not in the year displayed.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 2, 1);
      final DateTime selectedMonth = DateTime(2039, 3, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(2019),
              maxDate: DateTime(2040),
              displayedYearRange: DateTimeRange(start: DateTime(2018), end: DateTime(2029)),
              selectedDate: selectedMonth,
              theme: YearsPickerTheme(
                currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                selectedCellDecoration: const BoxDecoration(shape: BoxShape.circle),
                enabledCellsDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
              ),
            ),
          ),
        ),
      );

      final Finder selectedDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border == null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsNothing);
      expect(todayFinder, findsOneWidget);
    });

    testWidgets('should throw assertion error if minDate > maxDate', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime maxDate = DateTime.now().subtract(const Duration(days: 365 * 10));
      final DateTime minDate = DateTime.now().add(const Duration(days: 365 * 10));

      expect(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearView(
                currentDate: currentDate,
                onChanged: (DateTime date) {},
                minDate: minDate,
                maxDate: maxDate,
                displayedYearRange: DateTimeRange(start: DateTime(2018), end: DateTime(2029)),
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should throw assertion error if displayedYearRange was not 11 year', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime maxDate = DateTime.now().add(const Duration(days: 365 * 10));
      final DateTime minDate = DateTime.now().subtract(const Duration(days: 365 * 10));

      expect(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearView(
                currentDate: currentDate,
                onChanged: (DateTime date) {},
                minDate: minDate,
                maxDate: maxDate,
                displayedYearRange: DateTimeRange(start: DateTime(2018), end: DateTime(2050)),
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should disbale all the year before min date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2021);
      final DateTime minDate = DateTime(2020);
      final DateTime maxDate = DateTime(2029);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: const YearsPickerTheme(
                disabledCellsDecoration: BoxDecoration(color: Colors.green),
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics) {
          Widget? inner = widget.child;
          if (inner is Padding) inner = inner.child;
          if (inner is Container && inner.child is Center) {
            return (inner.decoration as BoxDecoration).color == Colors.green;
          }
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(3));
    });

    testWidgets('should disbale all the year after max date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020);
      final DateTime minDate = DateTime(2017);
      final DateTime maxDate = DateTime(2026);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: const YearsPickerTheme(
                disabledCellsDecoration: BoxDecoration(color: Colors.green),
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics) {
          Widget? inner = widget.child;
          if (inner is Padding) inner = inner.child;
          if (inner is Container && inner.child is Center) {
            return (inner.decoration as BoxDecoration).color == Colors.green;
          }
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(2));
    });

    testWidgets('should display enabled years with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2017, 1, 1),
              maxDate: DateTime(2028, 1, 1),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: YearsPickerTheme(
                enabledCellsTextStyle: TextStyle(color: customColor),
              ),
            ),
          ),
        ),
      );

      final Finder enabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.style?.color == customColor) {
          return true;
        }
        return false;
      });

      // Assuming there are 12 years in the displayed range
      // and the current year is in deferent color.
      expect(enabledDayFinder, findsNWidgets(11));

      await tester.ensureVisible(enabledDayFinder.first);
      await tester.ensureVisible(enabledDayFinder.last);
    });

    testWidgets('should display disabled years with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2021, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2020, 4, 1),
              maxDate: DateTime(2028, 12, 1),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: YearsPickerTheme(
                disabledCellsTextStyle: TextStyle(color: customColor),
              ),
            ),
          ),
        ),
      );

      final Finder disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.style?.color == customColor) {
          return true;
        }
        return false;
      });

      // there should be only 3 years that are disabled.
      expect(disabledDayFinder, findsNWidgets(3));

      await tester.ensureVisible(disabledDayFinder.first);
      await tester.ensureVisible(disabledDayFinder.last);
    });

    testWidgets('should display current year with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019),
              maxDate: DateTime(2022, 12, 1),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: YearsPickerTheme(
                currentDateTextStyle: TextStyle(color: customColor),
                currentDateDecoration: BoxDecoration(
                  border: Border.all(color: customColor),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder enabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            widget.decoration != null &&
            (widget.decoration as BoxDecoration).border == Border.all(color: customColor) &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).style?.color == customColor) {
          return true;
        }
        return false;
      });

      expect(enabledDayFinder, findsNWidgets(1));

      await tester.ensureVisible(enabledDayFinder.first);

      await tester.ensureVisible(enabledDayFinder.last);
    });

    testWidgets('should display selected year with the correct color', (WidgetTester tester) async {
      const Color textColor = Colors.green;
      const Color fillColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019),
              maxDate: DateTime(2021),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              selectedDate: DateTime(2020),
              theme: YearsPickerTheme(
                selectedCellTextStyle: TextStyle(color: textColor),
                selectedCellDecoration: BoxDecoration(color: fillColor),
              ),
            ),
          ),
        ),
      );

      final Finder enabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            widget.decoration != null &&
            (widget.decoration as BoxDecoration).border == null &&
            (widget.decoration as BoxDecoration).color == fillColor &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).style?.color == textColor) {
          return true;
        }
        return false;
      });

      expect(enabledDayFinder, findsNWidgets(1));

      await tester.ensureVisible(enabledDayFinder.first);
    });

    testWidgets('should select the right year when tap.', (WidgetTester tester) async {
      final dateToSelect = DateTime(2020);
      DateTime? selectedMonth;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2019),
              onChanged: (DateTime date) {
                selectedMonth = date;
              },
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
            ),
          ),
        ),
      );

      final clickbaleWidget = find.byWidgetPredicate((widget) => widget is InkResponse);

      expect(clickbaleWidget, findsNWidgets(3));

      final Finder monthFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).data == dateToSelect.year.toString()) {
          return true;
        }
        return false;
      });

      expect(monthFinder, findsNWidgets(1));

      await tester.ensureVisible(monthFinder.first);

      await tester.tap(clickbaleWidget.at(1));

      expect(selectedMonth, dateToSelect);
    });

    testWidgets(
      'Should not throw assertion when selected date at edge of max or min',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2017, 1, 1);
        final DateTime maxDate = DateTime(2028, 6, 29);
        final DateTime selectedDate = DateTime(2029, 6, 31);

        expect(
          () async {
            await tester.pumpWidget(
              MaterialApp(
                home: Material(
                  child: YearView(
                    currentDate: DateTime(2020, 1, 1),
                    onChanged: (DateTime date) {},
                    minDate: minDate,
                    maxDate: maxDate,
                    displayedYearRange: DateTimeRange(start: minDate, end: maxDate),
                    selectedDate: selectedDate,
                  ),
                ),
              ),
            );
          },
          throwsAssertionError,
        );
      },
    );

    testWidgets('should not call onChanged when a disabled year (before minDate) is tapped',
        (WidgetTester tester) async {
      bool callbackCalled = false;
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2028, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (_) => callbackCalled = true,
              minDate: minDate,
              maxDate: maxDate,
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
            ),
          ),
        ),
      );

      // 2018 is before minDate (2020) — it should be disabled
      final disabledYear = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics) {
          Widget? inner = widget.child;
          if (inner is Padding) inner = inner.child;
          if (inner is Container && inner.child is Center) {
            final text = (inner.child as Center).child;
            if (text is Text && text.data == '2018') return true;
          }
        }
        return false;
      });

      expect(disabledYear, findsOneWidget);
      await tester.tap(disabledYear, warnIfMissed: false);
      await tester.pump();

      expect(callbackCalled, isFalse);
    });

    testWidgets('uses theme cellsPadding for year cells', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(18);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (_) {},
              minDate: DateTime(2017),
              maxDate: DateTime(2028),
              displayedYearRange: DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              theme: const YearsPickerTheme(cellsPadding: customPadding),
            ),
          ),
        ),
      );

      final paddingFinder = find
          .descendant(
            of: find.byType(YearView),
            matching: find.widgetWithText(Padding, '2020'),
          )
          .at(0);
      expect(tester.widget<Padding>(paddingFinder).padding, customPadding);
    });
  });
}
