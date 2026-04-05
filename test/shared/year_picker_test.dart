import 'package:date_picker_plus/src/shared/header.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearsPicker', () {
    testWidgets('should show the correct leading header date', (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              displayedDate: displayedDate,
              currentDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder headerFinder = find.byType(Header);
      expect(headerFinder, findsOneWidget);

      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));

      expect(headerTextWidget.data, '2012 - 2023');
    });

    testWidgets('should change the page forward and backward on drag.', (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
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

      const String newDisplayedMonth = '2024 - 2035';

      await tester.drag(pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, newDisplayedMonth);

      await tester.drag(pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget =
          tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, '2012 - 2023');
    });

    testWidgets('should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              displayedDate: displayedDate,
              currentDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023');

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage + 1));

      const String newDisplayedMonth = '2024 - 2035';

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget =
          tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, newDisplayedMonth);
    });

    testWidgets('should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              displayedDate: displayedDate,
              currentDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

      final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023');

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage - 1));

      const String newDisplayedMonth = '2000 - 2011';

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget =
          tester.widget<Text>(find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, newDisplayedMonth);
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder previousPageIconFinder = find.byIcon(Icons.arrow_back_ios_rounded);
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
          '2000 - 2011',
        );

        await tester.tap(previousPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(newHeaderTextWidget.data, '2000 - 2011');
      },
    );

    testWidgets(
      'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage = tester.widget<PageView>(pageViewFinder).controller!.initialPage;

        final Finder nextPageIconFinder = find.byIcon(Icons.arrow_forward_ios_rounded);
        expect(nextPageIconFinder, findsOneWidget);

        final Finder headerFinder = find.byType(Header);
        final Text headerTextWidget = tester.widget<Text>(
          find.descendant(
            of: headerFinder,
            matching: find.byType(Text),
          ),
        );
        expect(headerTextWidget.data, '2000 - 2011');

        await tester.tap(nextPageIconFinder);
        await tester.pumpAndSettle();

        final int currentPage = tester.widget<PageView>(pageViewFinder).controller!.page!.round();

        expect(currentPage, equals(initialPage));

        final Finder newHeaderFinder = find.byType(Header);
        final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(
            of: newHeaderFinder,
            matching: find.byType(Text),
          ),
        );
        expect(newHeaderTextWidget.data, '2000 - 2011');
      },
    );

    testWidgets(
      'should NOT change the page forward and backward on drag when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

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
        expect(headerTextWidget.data, '2000 - 2011');

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
        expect(newHeaderTextWidget.data, '2000 - 2011');
      },
    );
    testWidgets(
      'Should show the correct year on pick',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        final DateTime yearToSelect = DateTime(2010);
        late final DateTime expectedYear;
        const selectedYearColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                onDateSelected: (value) {
                  expectedYear = value;
                },
              ),
            ),
          ),
        );

        final selectedYearFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.child is Center && (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == yearToSelect.year.toString() &&
                ((widget.child as Center).child as Text).style?.color == selectedYearColor;
          }
          return false;
        });

        final yearFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.child is Center && (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == yearToSelect.year.toString();
          }
          return false;
        });

        expect(selectedYearFinder, findsNothing);

        await tester.tap(yearFinder);
        await tester.pumpAndSettle();

        expect(expectedYear, yearToSelect);
      },
    );

    testWidgets(
      'Should show the correct text style for the leading date',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        const leadingDayColor = Colors.green;
        const customTextStyle = TextStyle(color: leadingDayColor);
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: const DatePickerPlusTheme(
                  headerTheme: HeaderTheme(
                    leadingDateTextStyle: customTextStyle,
                  ),
                ),
              ),
            ),
          ),
        );
        // 1. Find the widget visually by its text content
        final textFinder = find.text('2000 - 2011');
        expect(textFinder, findsOneWidget);
        // 2. Extract the specific widget from the widget tree
        final leadingDateText = tester.widget<Text>(textFinder);
        // 3. Assert its internal properties
        expect(leadingDateText.style?.color, equals(leadingDayColor));
      },
    );

    testWidgets(
      'Should render custom forward and backward arrow widgets from theme',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const customForwardKey = Key('custom_forward');
        const customBackwardKey = Key('custom_backward');
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                theme: const DatePickerPlusTheme(
                  headerTheme: HeaderTheme(
                    // Use simple placeholders with keys
                    forwardArrowWidget: SizedBox(key: customForwardKey),
                    backwardArrowWidget: SizedBox(key: customBackwardKey),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.byKey(customBackwardKey), findsOneWidget);
        expect(find.byKey(customForwardKey), findsOneWidget);
      },
    );

    testWidgets(
      'Should not throw assertion when initial date at edge of max or min',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2025, 6, 31);
        final DateTime minDate = DateTime(2024, 1, 1);
        final DateTime maxDate = DateTime(2024, 6, 29);

        expect(
          () async {
            await tester.pumpWidget(
              MaterialApp(
                home: Material(
                  child: YearsPicker(
                    displayedDate: displayedDate,
                    currentDate: displayedDate,
                    minDate: minDate,
                    maxDate: maxDate,
                  ),
                ),
              ),
            );
          },
          throwsAssertionError,
        );
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
              child: YearsPicker(
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

    testWidgets('should call onLeadingDateTap when the year range header is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              minDate: DateTime(2010, 1, 1),
              maxDate: DateTime(2030, 12, 31),
              currentDate: DateTime(2022, 1, 1),
              onLeadingDateTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should pre-select a year when selectedDate is provided', (WidgetTester tester) async {
      final selectedDate = DateTime(2022, 1, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              minDate: DateTime(2010, 1, 1),
              maxDate: DateTime(2030, 12, 31),
              currentDate: DateTime(2022, 1, 1),
              selectedDate: selectedDate,
              theme: DatePickerPlusTheme(
                yearsPickerTheme: YearsPickerTheme(
                  selectedCellDecoration: const BoxDecoration(
                    color: Colors.indigo,
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
          return (widget.decoration as BoxDecoration).color == Colors.indigo;
        }
        return false;
      });

      expect(selectedCellFinder, findsOneWidget);
    });

    testWidgets('should update highlighted year when selectedDate changes via didUpdateWidget',
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
                      onPressed: () => setState(() => selectedDate = DateTime(2015, 1, 1)),
                      child: const Text('select'),
                    ),
                    YearsPicker(
                      minDate: DateTime(2010, 1, 1),
                      maxDate: DateTime(2030, 12, 31),
                      displayedDate: DateTime(2015, 1, 1),
                      currentDate: DateTime(2022, 1, 1),
                      selectedDate: selectedDate,
                      theme: DatePickerPlusTheme(
                        yearsPickerTheme: YearsPickerTheme(
                          selectedCellDecoration: const BoxDecoration(
                            color: Colors.indigo,
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
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.indigo),
        findsNothing,
      );

      await tester.tap(find.text('select'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container && w.decoration is BoxDecoration && (w.decoration as BoxDecoration).color == Colors.indigo),
        findsOneWidget,
      );
    });
  });
}
