import 'package:date_picker_plus/src/range/range_days_view.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';

RangeDecorationPainter? _nullPainter(TextDirection textDirection, Color? color, bool start) => null;

void main() {
  group('RangeRangeDaysView', () {
    testWidgets('should have no selected day when selectedEndDate & selectedStartDate is null',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              selectedEndDate: null,
              selectedStartDate: null,
            ),
          ),
        ),
      );

      final Finder selectedDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border == null && decoration.shape == BoxShape.circle && decoration.color == null;
        }
        return false;
      });

      expect(selectedDayFinder, findsNothing);
    });

    testWidgets('current date should be the only cell that highlighted with border.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime max = DateTime(currentDate.year + 2, currentDate.month, currentDate.day);
      final DateTime min = DateTime(currentDate.year - 2, currentDate.month, currentDate.day);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: min,
              maxDate: max,
              displayedMonth: currentDate,
              selectedEndDate: null,
              selectedStartDate: null,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                  enabledCellsDecoration: const BoxDecoration(),
                  selectedCellsDecoration: const BoxDecoration(),
                  selectedEdgeCellDecoration: const BoxDecoration(),
                  disabledCellsDecoration: const BoxDecoration(),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null && decoration.shape == BoxShape.circle && decoration.color == null;
        }
        return false;
      });

      expect(todayFinder, findsOneWidget);
    });

    testWidgets('current day should be ignored when it is within the selected range', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 2);
      final DateTime startDate = DateTime(2023, 1, 1);
      final DateTime endDate = DateTime(2023, 1, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              selectedEndDate: endDate,
              selectedStartDate: startDate,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                  selectedCellsDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder currentDay = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border != null && decoration?.shape == BoxShape.circle;
        }
        return false;
      });

      expect(currentDay, findsNothing);
    });

    testWidgets('current day should not be ignored when it is outside the selected range', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 1);
      final DateTime startDate = DateTime(2023, 1, 2);
      final DateTime endDate = DateTime(2023, 1, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              selectedEndDate: endDate,
              selectedStartDate: startDate,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                  selectedCellsDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder currentDay = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border != null && decoration?.shape == BoxShape.circle;
        }
        return false;
      });

      expect(currentDay, findsOneWidget);
    });

    testWidgets('should be one widget highlighted, when selected day is not in the month displayed.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 1);
      final DateTime startDate = DateTime(2023, 2, 2);
      final DateTime endDate = DateTime(2023, 2, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              selectedEndDate: endDate,
              selectedStartDate: startDate,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                  selectedCellsDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder currentDay = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border != null && decoration?.shape == BoxShape.circle;
        }
        return false;
      });

      expect(currentDay, findsOneWidget);

      final Finder rangeDays = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border != null && decoration?.shape == BoxShape.rectangle;
        }
        return false;
      });

      expect(rangeDays, findsNothing);
    });

    testWidgets('should show the correct highlight to the range', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 1);
      final DateTime startDate = DateTime(2023, 1, 1);
      final DateTime endDate = DateTime(2023, 1, 10);

      const numberOfCellDecorated = 8;
      const numberOfLeadingAndTrailing = 2;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              minDate: DateTime(
                currentDate.year - 2,
                currentDate.month,
                currentDate.day,
              ),
              maxDate: DateTime(
                currentDate.year + 2,
                currentDate.month,
                currentDate.day,
              ),
              currentDate: currentDate,
              displayedMonth: currentDate,
              selectedEndDate: endDate,
              selectedStartDate: startDate,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border()),
                  selectedCellsDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.red,
                  ),
                  selectedEdgeCellDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final Finder currentDay = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border != null && decoration!.shape == BoxShape.circle;
        }
        return false;
      });

      expect(currentDay, findsNothing);

      final Finder rangeDays = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border == null &&
              decoration?.shape == BoxShape.rectangle &&
              decoration?.color == Colors.red;
        }
        return false;
      });

      expect(rangeDays, findsNWidgets(numberOfCellDecorated));

      final Finder leadingAndTrailing = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final decoration = widget.decoration as BoxDecoration?;
          return decoration?.border == null &&
              decoration?.shape == BoxShape.circle &&
              decoration?.color == Colors.yellow;
        }
        return false;
      });

      expect(leadingAndTrailing, findsNWidgets(numberOfLeadingAndTrailing));
      await expectLater(
          find.byType(RangeDaysView), matchesGoldenFile('should_show_the_correct_highlight_to_the_range.png'));
    });

    testWidgets('should throw assertion error if minDate > maxDate', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 1);
      final DateTime min = DateTime(2023, 1, 1);
      final DateTime max = DateTime(2020, 1, 10);

      expect(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: RangeDaysView(
                minDate: min,
                maxDate: max,
                currentDate: currentDate,
                displayedMonth: currentDate,
                selectedEndDate: null,
                selectedStartDate: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should throw assertion error if selected Range bigger the max/min', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 1);
      final DateTime max = DateTime(2023, 1, 1);
      final DateTime min = DateTime(2020, 1, 10);
      final DateTime start = DateTime(2020, 1, 9);
      final DateTime end = DateTime(2023, 1, 11);

      expect(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: RangeDaysView(
                minDate: min,
                maxDate: max,
                currentDate: currentDate,
                displayedMonth: currentDate,
                selectedEndDate: end,
                selectedStartDate: start,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should disbale all the days before min date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 1, 25);
      final DateTime minDate = DateTime(2020, 1, 10);
      final DateTime maxDate = DateTime(2020, 1, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              minDate: minDate,
              maxDate: maxDate,
              currentDate: currentDate,
              displayedMonth: currentDate,
              selectedEndDate: null,
              selectedStartDate: null,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  disabledCellsDecoration: BoxDecoration(color: Colors.green),
                ),
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics && widget.child is Padding) {
          final padding = widget.child as Padding;
          if (padding.child is Container && (padding.child as Container).child is Center) {
            final container = padding.child as Container;
            return (container.decoration as BoxDecoration).color == Colors.green;
          }
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(9));
    });

    testWidgets('should disbale all the days after max date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 1, 25);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 1, 21);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              minDate: minDate,
              maxDate: maxDate,
              currentDate: currentDate,
              displayedMonth: currentDate,
              selectedEndDate: null,
              selectedStartDate: null,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  disabledCellsDecoration: BoxDecoration(color: Colors.green),
                ),
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics && widget.child is Padding) {
          final padding = widget.child as Padding;
          if (padding.child is Container && (padding.child as Container).child is Center) {
            final container = padding.child as Container;
            return (container.decoration as BoxDecoration).color == Colors.green;
          }
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(9));
    });

    testWidgets('should show the correct first day of the week based on locale.', (WidgetTester tester) async {
      const uSLocale = Locale('en', 'US');

      await GlobalMaterialLocalizations.delegate.load(uSLocale);

      final DateTime currentDate = DateTime(2020, 1, 15);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 1, 20);

      final List<String> weekdayNames = intl.DateFormat('', 'en').dateSymbols.SHORTWEEKDAYS;

      late final MaterialLocalizations localizations;

      await tester.pumpWidget(
        MaterialApp(
          locale: uSLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Material(
            child: Builder(builder: (context) {
              localizations = MaterialLocalizations.of(context);
              return RangeDaysView(
                minDate: minDate,
                maxDate: maxDate,
                currentDate: currentDate,
                displayedMonth: currentDate,
                selectedEndDate: null,
                selectedStartDate: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
              );
            }),
          ),
        ),
      );

      final int firstDayOfWeekIndex = localizations.firstDayOfWeekIndex;
      final String expectedFirstDayOfWeek = weekdayNames[firstDayOfWeekIndex].toUpperCase();

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Center && widget.child is Text && (widget.child as Text).data == expectedFirstDayOfWeek) {
          return true;
        }
        return false;
      });

      final RenderBox renderBox = tester.renderObject<RenderBox>(disabledDayFinder);
      final Offset topLeft = renderBox.localToGlobal(Offset.zero);

      expect(topLeft, equals(Offset.zero));
    });

    testWidgets('should display days\' names with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.blue; // Replace with your specific color

      final DateTime currentDate = DateTime(2020, 1, 15);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 1, 20);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              minDate: minDate,
              maxDate: maxDate,
              currentDate: currentDate,
              displayedMonth: currentDate,
              selectedEndDate: null,
              selectedStartDate: null,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                  daysPickerTheme: DaysPickerTheme(
                daysOfTheWeekTheme: DaysOfTheWeekTheme(
                  textStyle: TextStyle(color: customColor),
                ),
              )),
            ),
          ),
        ),
      );

      final Finder dayNameFinder = find.byWidgetPredicate((widget) {
        if (widget is Text && widget.style?.color == customColor) {
          return true;
        }
        return false;
      });

      expect(dayNameFinder, findsNWidgets(7)); // Assuming there are 7 days in a week

      // Verify that all day names have the correct color
      await tester.ensureVisible(dayNameFinder.first);
      expect(tester.widget<Text>(dayNameFinder.first).style?.color, customColor);

      await tester.ensureVisible(dayNameFinder.last);
      expect(tester.widget<Text>(dayNameFinder.last).style?.color, customColor);
    });

    testWidgets('should display enabled days with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;
      final DateTime currentDate = DateTime(2020, 1, 31);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 1, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              minDate: minDate,
              maxDate: maxDate,
              currentDate: currentDate,
              displayedMonth: currentDate,
              selectedEndDate: null,
              selectedStartDate: null,
              onEndDateChanged: (value) {},
              onStartDateChanged: (value) {},
              theme: DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  enabledCellsTextStyle: TextStyle(color: customColor),
                ),
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

      // Assuming there are 31 days in the displayed month
      // and the current day is in deferent color.
      expect(enabledDayFinder, findsNWidgets(30));

      await tester.ensureVisible(enabledDayFinder.first);
      await tester.ensureVisible(enabledDayFinder.last);
    });

    testWidgets('should select the right date range when tap.', (WidgetTester tester) async {
      final rangeToSelect = DateTimeRange(
        start: DateTime(2020, 1, 1),
        end: DateTime(2020, 1, 30),
      );

      DateTime? selectedStartDate;
      DateTime? selectedEndDate;

      Widget widget(DateTime? startDate, DateTime? endDate) => MaterialApp(
            home: Material(
              child: RangeDaysView(
                minDate: DateTime(2019, 1, 1),
                maxDate: DateTime(2021, 1, 1),
                currentDate: DateTime(2020, 1, 31),
                displayedMonth: DateTime(2020, 1, 1),
                selectedEndDate: endDate,
                selectedStartDate: startDate,
                onEndDateChanged: (value) {
                  selectedEndDate = value;
                },
                onStartDateChanged: (value) {
                  selectedStartDate = value;
                },
              ),
            ),
          );

      await tester.pumpWidget(
        widget(selectedStartDate, selectedEndDate),
      );

      // ensure the we're going to select is visible.
      final Finder rangeDaysFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && (widget.child as Center).child is Text) {
          final dayWidget = ((widget.child as Center).child as Text);

          final day = int.tryParse(dayWidget.data ?? '');

          if (day == null) return false;

          if (day >= rangeToSelect.start.day && day <= rangeToSelect.end.day) {
            return true;
          }

          return false;
        }
        return false;
      });

      expect(rangeDaysFinder, findsNWidgets(30));

      // we will select the range in reverse, selecting the end date first
      // to see if it will be eventually switched.

      await tester.tap(rangeDaysFinder.last);
      expect(selectedStartDate, rangeToSelect.end);

      await tester.pumpWidget(
        widget(selectedStartDate, selectedEndDate),
      );

      await tester.tap(rangeDaysFinder.first);

      await tester.pumpWidget(
        widget(selectedStartDate, selectedEndDate),
      );

      expect(selectedStartDate, rangeToSelect.start);
      expect(selectedEndDate, rangeToSelect.end);
    });

    testWidgets('should not paint range decoration when resolvePainter returns null', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2023, 1, 15);
      final DateTime startDate = DateTime(2023, 1, 5);
      final DateTime endDate = DateTime(2023, 1, 20);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              displayedMonth: currentDate,
              selectedStartDate: startDate,
              selectedEndDate: endDate,
              onStartDateChanged: (value) {},
              onEndDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(
                  resolvePainter: _nullPainter,
                ),
              ),
            ),
          ),
        ),
      );

      final painterFinder = find.byWidgetPredicate((widget) {
        if (widget is CustomPaint && widget.painter is RangeDecorationPainter) {
          return true;
        }
        return false;
      });

      expect(painterFinder, findsNothing);
    });

    testWidgets('cellsPadding wraps the CustomPaint for range edge cells', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(4);
      final DateTime currentDate = DateTime(2023, 1, 15);
      final DateTime startDate = DateTime(2023, 1, 5);
      final DateTime endDate = DateTime(2023, 1, 20);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              displayedMonth: currentDate,
              selectedStartDate: startDate,
              selectedEndDate: endDate,
              onStartDateChanged: (value) {},
              onEndDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(cellsPadding: customPadding),
              ),
            ),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((widget) {
        if (widget is! Padding || widget.padding != customPadding) return false;
        final child = widget.child;
        return child is CustomPaint && child.painter is RangeDecorationPainter;
      });

      expect(paddingFinder, findsNWidgets(2));
    });

    testWidgets('uses theme cellsPadding for day cells', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(6);
      final DateTime currentDate = DateTime(2020, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: currentDate,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: currentDate,
              selectedStartDate: null,
              selectedEndDate: null,
              onStartDateChanged: (value) {},
              onEndDateChanged: (value) {},
              theme: const DatePickerPlusTheme(
                rangePickerTheme: RangePickerTheme(cellsPadding: customPadding),
              ),
            ),
          ),
        ),
      );

      final paddingFinder = find.byWidgetPredicate((widget) {
        if (widget is! Padding || widget.padding != customPadding) return false;
        if (widget.child is! Container) return false;
        final center = (widget.child as Container).child;
        if (center is! Center) return false;
        final text = center.child;
        return text is Text && text.data == '15';
      });
      expect(paddingFinder, findsOneWidget);
    });
  });
}
