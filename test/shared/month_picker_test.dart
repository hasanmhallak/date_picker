import 'package:date_picker_plus/src/shared/header.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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

      final Text headerTextWidget = tester.widget<Text>(
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        displayedDate.year.toString(),
      );
    });

    testWidgets('should apply monthsPickerTheme padding around PageView',
        (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(12);
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
              displayedDate: displayedDate,
              currentDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
              theme: const DatePickerPlusTheme(
                monthsPickerTheme: MonthsPickerTheme(padding: customPadding),
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
            child: MonthPicker(
              displayedDate: displayedDate,
              minDate: minDate,
              maxDate: maxDate,
              currentDate: displayedDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final DateTime newDisplayedYear = DateTime(2021, 6, 1);

      await tester.drag(
          pageViewFinder, const Offset(-600, 0)); // Drag the page forward
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
        newDisplayedYear.year.toString(),
      );

      await tester.drag(
          pageViewFinder, const Offset(600, 0)); // Drag the page backward
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
        displayedDate.year.toString(),
      );
    });

    testWidgets(
        'should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2024, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        displayedDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage + 1));

      final DateTime newDisplayedYear = DateTime(2023, 7, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        displayedDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage - 1));

      final DateTime newDisplayedYear = DateTime(2021, 5, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        displayedDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage));

      final DateTime newDisplayedYear = DateTime(2020, 5, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page when tapping on the next page icon when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        displayedDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage));

      final DateTime newDisplayedYear = DateTime(2022, 7, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
        find.descendant(
          of: newHeaderFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        newHeaderTextWidget.data,
        newDisplayedYear.year.toString(),
      );
    });

    testWidgets(
        'should NOT change the page forward and backward on drag when the range in max and min date are one year.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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

      final DateTime newDisplayedYear = DateTime(2020, 6, 1);

      await tester.drag(
          pageViewFinder, const Offset(-600, 0)); // Drag the page forward
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
        newDisplayedYear.year.toString(),
      );

      await tester.drag(
          pageViewFinder, const Offset(600, 0)); // Drag the page backward
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
        displayedDate.year.toString(),
      );
    });

    testWidgets(
      'Should show the correct month on pick',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010, 2);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        final DateTime monthToSelect = DateTime(2010);
        late final DateTime expectedMonth;
        const selectedYearColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: MonthPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                onDateSelected: (value) {
                  expectedMonth = value;
                },
              ),
            ),
          ),
        );

        final selectedMonthFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == 'Jan' &&
                ((widget.child as Center).child as Text).style?.color ==
                    selectedYearColor;
          }
          return false;
        });

        final monthFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data == 'Jan';
          }
          return false;
        });

        expect(selectedMonthFinder, findsNothing);

        await tester.tap(monthFinder);
        await tester.pumpAndSettle();

        expect(expectedMonth, monthToSelect);
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
              child: MonthPicker(
                displayedDate: displayedDate,
                currentDate: displayedDate,
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
            return widget.data == '2010' &&
                widget.style?.color == leadingDayColor;
          }
          return false;
        });

        expect(leadingDayFinder, findsOneWidget);
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
              child: MonthPicker(
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
        final DateTime displayedDate = DateTime(2024, 6, 31);
        final DateTime minDate = DateTime(2024, 1, 1);
        final DateTime maxDate = DateTime(2024, 6, 29);

        expect(
          () async {
            await tester.pumpWidget(
              MaterialApp(
                home: Material(
                  child: MonthPicker(
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
        final DateTime maxDate = DateTime(2010);

        int numberOfScrollListenerCalled = 0;

        void scrollListener() => numberOfScrollListenerCalled++;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: MonthPicker(
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

    testWidgets('should call onLeadingDateTap when the year header is tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 1, 1),
              onLeadingDateTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should pre-select a month when selectedDate is provided',
        (WidgetTester tester) async {
      final selectedDate = DateTime(2022, 3, 1); // March

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 1, 1),
              selectedDate: selectedDate,
              theme: DatePickerPlusTheme(
                monthsPickerTheme: MonthsPickerTheme(
                  selectedCellDecoration: const BoxDecoration(
                    color: Colors.teal,
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
          return (widget.decoration as BoxDecoration).color == Colors.teal;
        }
        return false;
      });

      expect(selectedCellFinder, findsOneWidget);
    });

    testWidgets(
        'should update highlighted month when selectedDate changes via didUpdateWidget',
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
                          setState(() => selectedDate = DateTime(2022, 5, 1)),
                      child: const Text('select'),
                    ),
                    MonthPicker(
                      minDate: DateTime(2020, 1, 1),
                      maxDate: DateTime(2025, 12, 31),
                      displayedDate: DateTime(2022, 5, 1),
                      selectedDate: selectedDate,
                      theme: DatePickerPlusTheme(
                        monthsPickerTheme: MonthsPickerTheme(
                          selectedCellDecoration: const BoxDecoration(
                            color: Colors.teal,
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
            (w.decoration as BoxDecoration).color == Colors.teal),
        findsNothing,
      );

      await tester.tap(find.text('select'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.teal),
        findsOneWidget,
      );
    });
  });
}
