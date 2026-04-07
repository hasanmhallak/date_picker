import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/shared/header.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DaysPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder headerFinder = find.byType(Header);
      expect(headerFinder, findsOneWidget);

      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate));
    });

    testWidgets('should apply daysPickerTheme padding around PageView',
        (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(12);
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
              theme: const DatePickerPlusTheme(
                daysPickerTheme: DaysPickerTheme(padding: customPadding),
              ),
            ),
          ),
        ),
      );

      final pageView = find.byType(PageView);
      final padding = tester.widget<Padding>(
        find.ancestor(
          of: pageView,
          matching: find.byWidgetPredicate(
            (w) => w is Padding && w.child is PageView,
          ),
        ),
      );
      expect(padding.padding.resolve(TextDirection.ltr), customPadding);
    });

    testWidgets('should change the page forward and backward on drag.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final DateTime newDisplayedMonth = DateTime(2020, 7, 1);

      await tester.drag(
          pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedMonth));

      await tester.drag(
          pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(displayedDate));
    });

    testWidgets(
        'should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);
      late final DatePickerPlusTheme theme;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(builder: (context) {
              theme = DatePickerPlusTheme.defaults(context);
              return DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: theme,
              );
            }),
          ),
        ),
      );

      final localizations =
          MaterialLocalizations.of(tester.element(find.byType(Header)));

      final Finder nextPageWidgetFinder =
          find.byWidget(theme.headerTheme!.forwardArrowWidget!);

      expect(nextPageWidgetFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final String expectedHeaderText =
          localizations.formatMonthYear(displayedDate);
      expect(
          find.descendant(
              of: headerFinder, matching: find.text(expectedHeaderText)),
          findsOneWidget);

      await tester.tap(nextPageWidgetFinder);
      await tester.pumpAndSettle();

      final DateTime newDisplayedMonth = DateTime(2022, 7, 1);

      final String expectedNewText =
          localizations.formatMonthYear(newDisplayedMonth);
      expect(
        find.descendant(of: headerFinder, matching: find.text(expectedNewText)),
        findsOneWidget,
      );
    });

    testWidgets(
        'should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);
      late final DatePickerPlusTheme theme;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(builder: (context) {
              theme = DatePickerPlusTheme.defaults(context);
              return DaysPicker(
                theme: theme,
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              );
            }),
          ),
        ),
      );

      final localizations =
          MaterialLocalizations.of(tester.element(find.byType(Header)));

      final Finder headerFinder = find.byType(Header);
      final String expectedInitialText =
          localizations.formatMonthYear(displayedDate);
      expect(
          find.descendant(
              of: headerFinder, matching: find.text(expectedInitialText)),
          findsOneWidget);

      final Finder previousPageIconFinder =
          find.byWidget(theme.headerTheme!.backwardArrowWidget!);
      expect(previousPageIconFinder, findsOneWidget);

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final DateTime newDisplayedMonth = DateTime(2022, 5, 1);
      final String expectedNewText =
          localizations.formatMonthYear(newDisplayedMonth);
      expect(
        find.descendant(of: headerFinder, matching: find.text(expectedNewText)),
        findsOneWidget,
      );
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2020, 1, 5);
        final DateTime minDate = DateTime(2020, 1, 1);
        final DateTime maxDate = DateTime(2020, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder previousPageIconFinder =
            find.byIcon(Icons.arrow_back_ios_rounded);
        expect(previousPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate),
        );

        await tester.tap(previousPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final DateTime newDisplayedYear = DateTime(2020, 1, 1);

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );
      },
    );

    testWidgets(
      'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2022, 1, 1);
        final DateTime minDate = DateTime(2022, 1, 1);
        final DateTime maxDate = DateTime(2022, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder nextPageIconFinder =
            find.byIcon(Icons.arrow_forward_ios_rounded);
        expect(nextPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate),
        );

        await tester.tap(nextPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final DateTime newDisplayedYear = DateTime(2022, 1, 1);

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );
      },
    );

    testWidgets(
      'should NOT change the page forward and backward on drag when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2020, 1, 1);
        final DateTime minDate = DateTime(2020, 1, 1);
        final DateTime maxDate = DateTime(2020, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final DateTime newDisplayedYear = DateTime(2020, 1, 1);

        await tester.drag(
          pageViewFinder,
          const Offset(-600, 0),
        ); // Drag the page forward
        await tester.pumpAndSettle();

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(newDisplayedYear),
        );

        await tester.drag(
          pageViewFinder,
          const Offset(600, 0),
        ); // Drag the page backward
        await tester.pumpAndSettle();

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate),
        );
      },
    );

    testWidgets(
      'Should show the correct day on pick',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        final DateTime dayToSelect = DateTime(2010, 1, 2);
        late final DateTime expectedDay;
        const selectedDayColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: DatePickerPlusTheme(
                  daysPickerTheme: DaysPickerTheme(
                    selectedCellTextStyle: TextStyle(color: selectedDayColor),
                  ),
                ),
                onDateSelected: (value) {
                  expectedDay = value;
                },
              ),
            ),
          ),
        );

        final selectedDayFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data ==
                    dayToSelect.day.toString() &&
                ((widget.child as Center).child as Text).style?.color ==
                    selectedDayColor;
          }
          return false;
        });

        final dayFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data ==
                dayToSelect.day.toString();
          }
          return false;
        });

        expect(selectedDayFinder, findsNothing);

        await tester.tap(dayFinder);
        await tester.pumpAndSettle();

        expect(expectedDay, dayToSelect);
      },
    );
    testWidgets(
      'Should show the correct text style for the leading date',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const leadingDayColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: DatePickerPlusTheme(
                  headerTheme: HeaderTheme(
                    leadingDateTextStyle: TextStyle(color: leadingDayColor),
                  ),
                ),
              ),
            ),
          ),
        );

        final leadingDayFinder = find.byWidgetPredicate((widget) {
          if (widget is Text) {
            return widget.data == 'January 2010' &&
                widget.style?.color == leadingDayColor;
          }
          return false;
        });

        expect(leadingDayFinder, findsOneWidget);
      },
    );

    testWidgets(
      'Should show custom arrow widgets for page arrow buttons',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const backKey = Key('back-arrow');
        const forwardKey = Key('forward-arrow');

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: const DatePickerPlusTheme(
                  headerTheme: HeaderTheme(
                    backwardArrowWidget: Icon(Icons.arrow_back, key: backKey),
                    forwardArrowWidget:
                        Icon(Icons.arrow_forward, key: forwardKey),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(backKey), findsOneWidget);
        expect(find.byKey(forwardKey), findsOneWidget);
      },
    );

    testWidgets(
      'Should not scroll when first open',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2023);

        int numberOfScrollListenerCalled = 0;

        void scrollListener() => numberOfScrollListenerCalled++;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final pageViewWidget = tester.widget<PageView>(find.byType(PageView));
        pageViewWidget.controller!.addListener(scrollListener);

        await tester.pumpAndSettle();

        expect(numberOfScrollListenerCalled, equals(0));
      },
    );

    testWidgets('should call onLeadingDateTap when the header date is tapped',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              onLeadingDateTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should pre-select a date when selectedDate is provided',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime selectedDate = DateTime(2022, 6, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              selectedDate: selectedDate,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
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

      final selectedCellFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          return (widget.decoration as BoxDecoration).color == Colors.purple;
        }
        return false;
      });

      expect(selectedCellFinder, findsOneWidget);
    });

    testWidgets(
        'should not call onDateSelected when a disabled (predicate) day is tapped',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              disabledDayPredicate: (date) => date.day == 10,
              onDateSelected: (_) => callbackCalled = true,
            ),
          ),
        ),
      );

      // Day 10 should be wrapped in ExcludeSemantics (disabled), tap it
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

      expect(callbackCalled, isFalse);
    });

    testWidgets(
        'should throw assertion error when displayedDate is before minDate',
        (WidgetTester tester) async {
      expect(
        () => DaysPicker(
          currentDate: DateTime(2022, 6, 1),
          displayedDate: DateTime(2021, 12, 31),
          minDate: DateTime(2022, 1, 1),
          maxDate: DateTime(2022, 12, 31),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
        'should throw assertion error when displayedDate is after maxDate',
        (WidgetTester tester) async {
      expect(
        () => DaysPicker(
          currentDate: DateTime(2022, 6, 1),
          displayedDate: DateTime(2023, 1, 1),
          minDate: DateTime(2022, 1, 1),
          maxDate: DateTime(2022, 12, 31),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
        'should update displayed month when displayedDate changes via didUpdateWidget',
        (WidgetTester tester) async {
      DateTime displayedDate = DateTime(2022, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => displayedDate = DateTime(2022, 6, 1)),
                      child: const Text('change'),
                    ),
                    DaysPicker(
                      currentDate: displayedDate,
                      displayedDate: displayedDate,
                      minDate: DateTime(2022, 1, 1),
                      maxDate: DateTime(2022, 12, 31),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final headerFinder = find.byType(Header);
      final textBefore = tester
          .widget<Text>(
              find.descendant(of: headerFinder, matching: find.byType(Text)))
          .data;
      expect(textBefore, contains('January'));

      await tester.tap(find.text('change'));
      await tester.pumpAndSettle();

      final textAfter = tester
          .widget<Text>(
              find.descendant(of: headerFinder, matching: find.byType(Text)))
          .data;
      expect(textAfter, contains('June'));
    });

    testWidgets(
        'should update highlighted cell when selectedDate changes via didUpdateWidget',
        (WidgetTester tester) async {
      DateTime? selectedDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => selectedDate = DateTime(2022, 6, 10)),
                      child: const Text('select'),
                    ),
                    DaysPicker(
                      currentDate: DateTime(2022, 6, 1),
                      displayedDate: DateTime(2022, 6, 1),
                      selectedDate: selectedDate,
                      minDate: DateTime(2022, 1, 1),
                      maxDate: DateTime(2022, 12, 31),
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
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.purple),
        findsNothing,
      );

      await tester.tap(find.text('select'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.purple),
        findsOneWidget,
      );
    });

    testWidgets('should not call onDateSelected when theme isEnabled is false',
        (WidgetTester tester) async {
      DateTime? result;
      final DateTime displayedDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              theme: const DatePickerPlusTheme(isEnabled: false),
              onDateSelected: (date) => result = date,
            ),
          ),
        ),
      );

      final Finder dayFinder = find.byWidgetPredicate((widget) {
        if (widget is Semantics &&
            widget.properties.label?.startsWith('10,') == true) {
          return true;
        }
        return false;
      });

      await tester.tap(dayFinder.first);
      await tester.pump();

      expect(result, isNull);
    });

    testWidgets('should not change month on drag when theme isEnabled is false',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2020, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysPicker(
              currentDate: displayedDate,
              displayedDate: displayedDate,
              minDate: DateTime(2000, 1, 1),
              maxDate: DateTime(2030, 12, 31),
              theme: const DatePickerPlusTheme(isEnabled: false),
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      await tester.drag(pageViewFinder, const Offset(-600, 0));
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
        headerTextWidget.data,
        MaterialLocalizations.of(tester.element(headerFinder))
            .formatMonthYear(displayedDate),
      );
    });

    group('onDisplayedMonthChanged', () {
      testWidgets('calls with first day of initial month on first build',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 6, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 12, 31),
                onDisplayedMonthChanged: calls.add,
              ),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 6, 1)]);
      });

      testWidgets('calls with next month when dragging forward',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 6, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2000, 1, 1),
                maxDate: DateTime(2030, 12, 31),
                onDisplayedMonthChanged: calls.add,
              ),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 6, 1)]);

        await tester.drag(find.byType(PageView), const Offset(-600, 0));
        await tester.pumpAndSettle();

        expect(calls.last, DateTime(2022, 7, 1));
        expect(calls.length, 2);
      });

      testWidgets('calls with previous month when dragging backward from July',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 7, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: DaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2000, 1, 1),
                maxDate: DateTime(2030, 12, 31),
                onDisplayedMonthChanged: calls.add,
              ),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 7, 1)]);

        await tester.drag(find.byType(PageView), const Offset(600, 0));
        await tester.pumpAndSettle();

        expect(calls.last, DateTime(2022, 6, 1));
        expect(calls.length, 2);
      });

      testWidgets('calls with next month when tapping forward arrow',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 6, 1);
        late final DatePickerPlusTheme theme;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Builder(builder: (context) {
                theme = DatePickerPlusTheme.defaults(context);
                return DaysPicker(
                  currentDate: displayedDate,
                  displayedDate: displayedDate,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  theme: theme,
                  onDisplayedMonthChanged: calls.add,
                );
              }),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 6, 1)]);

        await tester.tap(find.byWidget(theme.headerTheme!.forwardArrowWidget!));
        await tester.pumpAndSettle();

        expect(calls.last, DateTime(2022, 7, 1));
        expect(calls.length, 2);
      });

      testWidgets(
          'calls with previous month when tapping backward arrow from July',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 7, 1);
        late final DatePickerPlusTheme theme;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Builder(builder: (context) {
                theme = DatePickerPlusTheme.defaults(context);
                return DaysPicker(
                  currentDate: displayedDate,
                  displayedDate: displayedDate,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  theme: theme,
                  onDisplayedMonthChanged: calls.add,
                );
              }),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 7, 1)]);

        await tester
            .tap(find.byWidget(theme.headerTheme!.backwardArrowWidget!));
        await tester.pumpAndSettle();

        expect(calls.last, DateTime(2022, 6, 1));
        expect(calls.length, 2);
      });

      testWidgets('calls when displayedDate changes via didUpdateWidget',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        DateTime displayedDate = DateTime(2022, 6, 1);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(
                            () => displayedDate = DateTime(2022, 8, 1)),
                        child: const Text('jump'),
                      ),
                      DaysPicker(
                        currentDate: displayedDate,
                        displayedDate: displayedDate,
                        minDate: DateTime(2022, 1, 1),
                        maxDate: DateTime(2022, 12, 31),
                        onDisplayedMonthChanged: calls.add,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(calls, [DateTime(2022, 6, 1)]);

        await tester.tap(find.text('jump'));
        await tester.pumpAndSettle();

        expect(calls.last, DateTime(2022, 8, 1));
        expect(calls.length, 2);
      });
    });
  });
}
