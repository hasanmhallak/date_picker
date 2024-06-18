import 'package:date_picker_plus/src/date/days_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('DaysView', () {
    testWidgets('should have no selected day when selectedDate is null', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

    testWidgets('today should be the only cell that highlighted with border.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null && decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(todayFinder, findsOneWidget);
    });

    testWidgets('should be two widget highlighted, Today with border, and selected day with fill color.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime selectedDate = DateTime(
        currentDate.year,
        currentDate.month,
        //* to avoid being overlaping.
        currentDate.day != 1 ? 1 : 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              selectedDate: selectedDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              selectedDayDecoration: const BoxDecoration(shape: BoxShape.circle),
              enabledCellsDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

    testWidgets('should be one widget highlighted, when selected day is not in the month displayed.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime selectedDate = DateTime(
        currentDate.year,
        currentDate.month + 1,
        //* to avoid being overlaping.
        currentDate.day != 1 ? 1 : 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(currentDate.year + 2, currentDate.month, currentDate.day),
              displayedMonth: currentDate,
              selectedDate: selectedDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(shape: BoxShape.circle),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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
              child: DaysView(
                currentDate: currentDate,
                onChanged: (DateTime date) {},
                minDate: minDate,
                maxDate: maxDate,
                displayedMonth: currentDate,
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                enabledCellsTextStyle: const TextStyle(),
                selectedDayTextStyle: const TextStyle(),
                disabledCellsTextStyle: const TextStyle(),
                currentDateDecoration: const BoxDecoration(),
                enabledCellsDecoration: const BoxDecoration(),
                selectedDayDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
                splashColor: Colors.black,
                highlightColor: Colors.black,
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should disbale all the days before min date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 1, 25);
      final DateTime minDate = DateTime(2020, 1, 10);
      final DateTime maxDate = DateTime(2020, 1, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedMonth: currentDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
              disabledCellsDecoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics && widget.child is Container && (widget.child as Container).child is Center) {
          final container = widget.child as Container;
          return (container.decoration as BoxDecoration).color == Colors.green;
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(10));
    });

    testWidgets('should disbale all the days after max date.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 1, 15);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 1, 20);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedMonth: currentDate,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
              disabledCellsDecoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics && widget.child is Container && (widget.child as Container).child is Center) {
          final container = widget.child as Container;
          return (container.decoration as BoxDecoration).color == Colors.green;
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(11));
    });

    testWidgets('should disbale all the days provided in disabledDayPredicate.', (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2021);
      final DateTime displayedMonth = DateTime(2023);
      final DateTime minDate = DateTime(2020);
      final DateTime maxDate = DateTime(2024);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              disabledDayPredicate: (date) {
                return date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;
              },
              minDate: minDate,
              maxDate: maxDate,
              displayedMonth: displayedMonth,
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
              disabledCellsDecoration: const BoxDecoration(
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      final disabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is ExcludeSemantics && widget.child is Container && (widget.child as Container).child is Center) {
          final container = widget.child as Container;
          return (container.decoration as BoxDecoration).color == Colors.green;
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
              return DaysView(
                currentDate: currentDate,
                onChanged: (DateTime date) {},
                minDate: minDate,
                maxDate: maxDate,
                displayedMonth: currentDate,
                currentDateTextStyle: const TextStyle(),
                daysOfTheWeekTextStyle: const TextStyle(),
                enabledCellsTextStyle: const TextStyle(),
                selectedDayTextStyle: const TextStyle(),
                disabledCellsTextStyle: const TextStyle(),
                currentDateDecoration: const BoxDecoration(),
                enabledCellsDecoration: const BoxDecoration(),
                selectedDayDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
                splashColor: Colors.black,
                highlightColor: Colors.black,
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

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime.now(),
              onChanged: (DateTime date) {},
              minDate: DateTime(2024),
              maxDate: DateTime(2024),
              displayedMonth: DateTime.now(),
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(
                color: customColor,
              ),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedMonth: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(
                color: customColor,
              ),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

    testWidgets('should display disabled days with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 11),
              onChanged: (DateTime date) {},
              minDate: DateTime(2020, 1, 10),
              maxDate: DateTime(2021, 1, 1),
              displayedMonth: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(
                color: customColor,
              ),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

      // there should be only 9 days that are disabled.
      expect(disabledDayFinder, findsNWidgets(9));

      await tester.ensureVisible(disabledDayFinder.first);
      await tester.ensureVisible(disabledDayFinder.last);
    });

    testWidgets('should display today with the correct color', (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (DateTime date) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedMonth: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(
                color: customColor,
              ),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: BoxDecoration(
                  border: Border.all(
                color: customColor,
              )),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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

    testWidgets('should display selected day with the correct color', (WidgetTester tester) async {
      const Color textColor = Colors.green;
      const Color fillColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (DateTime date) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedMonth: DateTime(2020, 1, 1),
              selectedDate: DateTime(2020, 1, 11),
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(
                color: textColor,
              ),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(
                color: fillColor,
              ),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
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
    testWidgets('should select the right date when tap.', (WidgetTester tester) async {
      final dateToSelect = DateTime(2020, 1, 4);
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (DateTime date) {
                selectedDate = date;
              },
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedMonth: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              daysOfTheWeekTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedDayTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedDayDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final clickbaleWidget = find.byWidgetPredicate((widget) => widget is InkResponse);

      expect(clickbaleWidget, findsNWidgets(31)); // Assuming there are 31 days in the displayed month

      final Finder enabledDayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).data == dateToSelect.day.toString()) {
          return true;
        }
        return false;
      });

      expect(enabledDayFinder, findsNWidgets(1));

      await tester.ensureVisible(enabledDayFinder.first);

      await tester.tap(clickbaleWidget.at(dateToSelect.day - 1));

      expect(selectedDate, dateToSelect);
    });
  });
}
