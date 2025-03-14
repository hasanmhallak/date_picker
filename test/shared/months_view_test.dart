import 'package:date_picker_plus/src/shared/month_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('MonthView', () {
    testWidgets('should have no selected month when selectedMonth is null',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(
                  currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(
                  currentDate.year + 2, currentDate.month, currentDate.day),
              displayedDate: currentDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
          return decoration.border == null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsNothing);
    });

    testWidgets('should highlight this month only.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(
                  currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(
                  currentDate.year + 2, currentDate.month, currentDate.day),
              displayedDate: currentDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration:
                  BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder thisMonthFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(thisMonthFinder, findsOneWidget);
    });

    testWidgets(
        'should be two widget highlighted, thisMonth with border, and selected month with fill color.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 2, 1);
      final DateTime selectedMonth = DateTime(2020, 3, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(
                  currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(
                  currentDate.year + 2, currentDate.month, currentDate.day),
              displayedDate: currentDate,
              selectedDate: selectedMonth,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration:
                  BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration:
                  const BoxDecoration(shape: BoxShape.circle),
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
          return decoration.border == null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsOneWidget);
      expect(todayFinder, findsOneWidget);
    });

    testWidgets(
        'should be one widget highlighted, when selected month is not in the year displayed.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 2, 1);
      final DateTime selectedMonth = DateTime(2021, 3, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: DateTime(
                  currentDate.year - 2, currentDate.month, currentDate.day),
              maxDate: DateTime(
                  currentDate.year + 2, currentDate.month, currentDate.day),
              displayedDate: currentDate,
              selectedDate: selectedMonth,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration:
                  BoxDecoration(shape: BoxShape.circle, border: Border.all()),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration:
                  const BoxDecoration(shape: BoxShape.circle),
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
          return decoration.border == null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      final Finder todayFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration != null) {
          final BoxDecoration decoration = widget.decoration as BoxDecoration;
          return decoration.border != null &&
              decoration.shape == BoxShape.circle;
        }
        return false;
      });

      expect(selectedDayFinder, findsNothing);
      expect(todayFinder, findsOneWidget);
    });

    testWidgets('should throw assertion error if minDate > maxDate',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime.now();
      final DateTime maxDate =
          DateTime.now().subtract(const Duration(days: 365 * 10));
      final DateTime minDate =
          DateTime.now().add(const Duration(days: 365 * 10));

      expect(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: MonthView(
                currentDate: currentDate,
                onChanged: (DateTime date) {},
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: currentDate,
                currentDateTextStyle: const TextStyle(),
                enabledCellsTextStyle: const TextStyle(),
                selectedCellTextStyle: const TextStyle(),
                disabledCellsTextStyle: const TextStyle(),
                currentDateDecoration: const BoxDecoration(),
                enabledCellsDecoration: const BoxDecoration(),
                selectedCellDecoration: const BoxDecoration(),
                disabledCellsDecoration: const BoxDecoration(),
                splashColor: Colors.black,
                highlightColor: Colors.black,
              ),
            ),
          ),
        );
      }, throwsAssertionError);
    });

    testWidgets('should disbale all the months before min date.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 5, 1);
      final DateTime minDate = DateTime(2020, 4, 1);
      final DateTime maxDate = DateTime(2020, 12, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedDate: currentDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
        if (widget is ExcludeSemantics &&
            widget.child is Container &&
            (widget.child as Container).child is Center) {
          final container = widget.child as Container;
          return (container.decoration as BoxDecoration).color == Colors.green;
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(3));
    });

    testWidgets('should disbale all the months after max date.',
        (WidgetTester tester) async {
      final DateTime currentDate = DateTime(2020, 5, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 10, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: currentDate,
              onChanged: (DateTime date) {},
              minDate: minDate,
              maxDate: maxDate,
              displayedDate: currentDate,
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
        if (widget is ExcludeSemantics &&
            widget.child is Container &&
            (widget.child as Container).child is Center) {
          final container = widget.child as Container;
          return (container.decoration as BoxDecoration).color == Colors.green;
        }
        return false;
      });
      expect(disabledDayFinder, findsNWidgets(2));
    });

    testWidgets('should display enabled months with the correct color',
        (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedDate: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(
                color: customColor,
              ),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
      expect(enabledDayFinder, findsNWidgets(11));

      await tester.ensureVisible(enabledDayFinder.first);
      await tester.ensureVisible(enabledDayFinder.last);
    });

    testWidgets('should display disabled months with the correct color',
        (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2021, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2021, 4, 1),
              maxDate: DateTime(2021, 12, 1),
              displayedDate: DateTime(2021, 1, 1),
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(
                color: customColor,
              ),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
      expect(disabledDayFinder, findsNWidgets(3));

      await tester.ensureVisible(disabledDayFinder.first);
      await tester.ensureVisible(disabledDayFinder.last);
    });

    testWidgets('should display current month with the correct color',
        (WidgetTester tester) async {
      const Color customColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 5, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 12, 1),
              displayedDate: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(
                color: customColor,
              ),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: BoxDecoration(
                border: Border.all(color: customColor),
              ),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
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
            (widget.decoration as BoxDecoration).border ==
                Border.all(color: customColor) &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).style?.color ==
                customColor) {
          return true;
        }
        return false;
      });

      expect(enabledDayFinder, findsNWidgets(1));

      await tester.ensureVisible(enabledDayFinder.first);

      await tester.ensureVisible(enabledDayFinder.last);
    });

    testWidgets('should display selected month with the correct color',
        (WidgetTester tester) async {
      const Color textColor = Colors.green;
      const Color fillColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedDate: DateTime(2020, 1, 1),
              selectedDate: DateTime(2020, 2, 1),
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(
                color: textColor,
              ),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(
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
            ((widget.child as Center).child as Text).style?.color ==
                textColor) {
          return true;
        }
        return false;
      });

      expect(enabledDayFinder, findsNWidgets(1));

      await tester.ensureVisible(enabledDayFinder.first);
    });

    testWidgets('should select the right month when tap.',
        (WidgetTester tester) async {
      const uSLocale = Locale('en', 'US');

      await GlobalMaterialLocalizations.delegate.load(uSLocale);
      final dateToSelect = DateTime(2020, 2, 1);
      DateTime? selectedMonth;

      final List<String> monthsNames =
          intl.DateFormat('', 'en').dateSymbols.STANDALONESHORTMONTHS;

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
            child: MonthView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {
                selectedMonth = date;
              },
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedDate: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final selectedMonthName = monthsNames[dateToSelect.month - 1];

      final clickbaleWidget =
          find.byWidgetPredicate((widget) => widget is InkResponse);

      expect(
          clickbaleWidget,
          findsNWidgets(
              12)); // Assuming there are 12 month in the displayed year

      final Finder monthFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).data ==
                selectedMonthName) {
          return true;
        }
        return false;
      });

      expect(monthFinder, findsNWidgets(1));

      await tester.ensureVisible(monthFinder.first);

      await tester.tap(clickbaleWidget.at(dateToSelect.month - 1));

      expect(selectedMonth, dateToSelect);
    });

    testWidgets('should show the correct names when locale changed.',
        (WidgetTester tester) async {
      const arLocale = Locale('ar');

      await GlobalMaterialLocalizations.delegate.load(arLocale);

      final List<String> monthName =
          intl.DateFormat('', 'ar').dateSymbols.STANDALONESHORTMONTHS;

      await tester.pumpWidget(
        MaterialApp(
          locale: arLocale,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 1, 1),
              onChanged: (DateTime date) {},
              minDate: DateTime(2019, 1, 1),
              maxDate: DateTime(2021, 1, 1),
              displayedDate: DateTime(2020, 1, 1),
              currentDateTextStyle: const TextStyle(),
              enabledCellsTextStyle: const TextStyle(),
              selectedCellTextStyle: const TextStyle(),
              disabledCellsTextStyle: const TextStyle(),
              currentDateDecoration: const BoxDecoration(),
              enabledCellsDecoration: const BoxDecoration(),
              selectedCellDecoration: const BoxDecoration(),
              disabledCellsDecoration: const BoxDecoration(),
              splashColor: Colors.black,
              highlightColor: Colors.black,
            ),
          ),
        ),
      );

      final Finder monthFinder = find.byWidgetPredicate((widget) {
        if (widget is Container &&
            (widget.child as Center).child is Text &&
            ((widget.child as Center).child as Text).data == monthName.first) {
          return true;
        }
        return false;
      });

      expect(monthFinder, findsNWidgets(1));
    });

    testWidgets(
      'Should not throw assertion when selected date at edge of max or min',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2024, 6, 31);
        final DateTime minDate = DateTime(2024, 1, 1);
        final DateTime selectedDate = DateTime(2024, 6, 31);
        final DateTime maxDate = DateTime(2024, 6, 29);

        expect(
          () async {
            await tester.pumpWidget(
              MaterialApp(
                home: Material(
                  child: MonthView(
                    currentDate: DateTime(2020, 1, 1),
                    onChanged: (DateTime date) {},
                    minDate: minDate,
                    maxDate: maxDate,
                    displayedDate: initialDate,
                    selectedDate: selectedDate,
                    currentDateTextStyle: const TextStyle(),
                    enabledCellsTextStyle: const TextStyle(),
                    selectedCellTextStyle: const TextStyle(),
                    disabledCellsTextStyle: const TextStyle(),
                    currentDateDecoration: const BoxDecoration(),
                    enabledCellsDecoration: const BoxDecoration(),
                    selectedCellDecoration: const BoxDecoration(),
                    disabledCellsDecoration: const BoxDecoration(),
                    splashColor: Colors.black,
                    highlightColor: Colors.black,
                  ),
                ),
              ),
            );
          },
          throwsAssertionError,
        );
      },
    );
  });
}
