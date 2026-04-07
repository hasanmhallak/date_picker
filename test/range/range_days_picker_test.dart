import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/range/range_days_picker.dart';
import 'package:date_picker_plus/src/shared/header.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeDaysPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
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
              return RangeDaysPicker(
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: displayedDate,
                onLeadingDateTap: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedEndDate: null,
                selectedStartDate: null,
              );
            }),
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

    testWidgets('should apply rangePickerTheme padding around PageView',
        (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(12);
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
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
              return RangeDaysPicker(
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: displayedDate,
                onLeadingDateTap: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedEndDate: null,
                selectedStartDate: null,
                theme: const DatePickerPlusTheme(
                  rangePickerTheme: RangePickerTheme(padding: customPadding),
                ),
              );
            }),
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
              return RangeDaysPicker(
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: displayedDate,
                onLeadingDateTap: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedEndDate: null,
                selectedStartDate: null,
              );
            }),
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

      await tester.pumpWidget(
        MaterialApp(
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
              return RangeDaysPicker(
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: displayedDate,
                onLeadingDateTap: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedEndDate: null,
                selectedStartDate: null,
              );
            }),
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
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate));

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage + 1));

      final DateTime newDisplayedMonth = DateTime(2022, 7, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(newDisplayedMonth));
    });

    testWidgets(
        'should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime displayedDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
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
              return RangeDaysPicker(
                currentDate: displayedDate,
                minDate: minDate,
                maxDate: maxDate,
                displayedDate: displayedDate,
                onLeadingDateTap: null,
                onEndDateChanged: (value) {},
                onStartDateChanged: (value) {},
                selectedEndDate: null,
                selectedStartDate: null,
              );
            }),
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
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(
          headerTextWidget.data,
          MaterialLocalizations.of(tester.element(headerFinder))
              .formatMonthYear(displayedDate));

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller!.page!.round();

      expect(currentPage, equals(initialPage - 1));

      final DateTime newDisplayedMonth = DateTime(2022, 5, 1);

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(
          newHeaderTextWidget.data,
          MaterialLocalizations.of(tester.element(newHeaderFinder))
              .formatMonthYear(newDisplayedMonth));
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2020, 1, 5);
        final DateTime minDate = DateTime(2020, 1, 1);
        final DateTime maxDate = DateTime(2020, 1, 31);

        await tester.pumpWidget(
          MaterialApp(
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
                return RangeDaysPicker(
                  currentDate: displayedDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  displayedDate: displayedDate,
                  onLeadingDateTap: null,
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedEndDate: null,
                  selectedStartDate: null,
                );
              }),
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
                return RangeDaysPicker(
                  currentDate: displayedDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  displayedDate: displayedDate,
                  onLeadingDateTap: null,
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedEndDate: null,
                  selectedStartDate: null,
                );
              }),
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
                return RangeDaysPicker(
                  currentDate: displayedDate,
                  minDate: minDate,
                  maxDate: maxDate,
                  displayedDate: displayedDate,
                  onLeadingDateTap: null,
                  onEndDateChanged: (value) {},
                  onStartDateChanged: (value) {},
                  selectedEndDate: null,
                  selectedStartDate: null,
                );
              }),
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
      'Should show the correct text style for the leading date',
      (WidgetTester tester) async {
        final DateTime displayedDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        const leadingDayColor = Colors.green;
        const customTextStyle = TextStyle(color: leadingDayColor);

        await tester.pumpWidget(
          MaterialApp(
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
              child: Builder(
                builder: (context) {
                  return RangeDaysPicker(
                    currentDate: displayedDate,
                    minDate: minDate,
                    maxDate: maxDate,
                    displayedDate: displayedDate,
                    theme: const DatePickerPlusTheme(
                      headerTheme: HeaderTheme(
                        leadingDateTextStyle: customTextStyle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // 1. Find the widget visually by its text content
        final textFinder = find.text('January 2010');
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
              child: RangeDaysPicker(
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
      'Should not scroll when first open',
      (WidgetTester tester) async {
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2023);

        int numberOfScrollListenerCalled = 0;

        void scrollListener() => numberOfScrollListenerCalled++;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: RangeDaysPicker(
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
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2025, 12, 31),
              currentDate: DateTime(2022, 6, 1),
              displayedDate: DateTime(2022, 6, 1),
              onLeadingDateTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should call onStartDateChanged on first tap',
        (WidgetTester tester) async {
      DateTime? startDate;
      final currentDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysPicker(
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              currentDate: currentDate,
              displayedDate: currentDate,
              onStartDateChanged: (d) => startDate = d,
            ),
          ),
        ),
      );

      final day5 = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.child is Center) {
          final text = (widget.child as Center).child;
          if (text is Text && text.data == '5') return true;
        }
        return false;
      });

      await tester.tap(day5.first);
      await tester.pump();

      expect(startDate, isNotNull);
      expect(startDate!.day, equals(5));
    });

    testWidgets(
        'should swap start and end when selected end is before existing start',
        (WidgetTester tester) async {
      // When user selects an end date before the existing start, the widget
      // should swap: the tapped date becomes the new start, the old start becomes the end.
      DateTime? startDate;
      DateTime? endDate;
      final currentDate = DateTime(2022, 6, 1);

      Widget buildWidget(DateTime? start, DateTime? end) => MaterialApp(
            home: Material(
              child: RangeDaysPicker(
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 12, 31),
                currentDate: currentDate,
                displayedDate: currentDate,
                selectedStartDate: start,
                selectedEndDate: end,
                onStartDateChanged: (d) => startDate = d,
                onEndDateChanged: (d) => endDate = d,
              ),
            ),
          );

      await tester.pumpWidget(buildWidget(null, null));

      // First tap: set start = June 15
      final day15 = find.byWidgetPredicate((w) {
        if (w is Container && w.child is Center) {
          final text = (w.child as Center).child;
          if (text is Text && text.data == '15') return true;
        }
        return false;
      });
      await tester.tap(day15.first);
      await tester.pump();
      expect(startDate!.day, equals(15));

      await tester.pumpWidget(buildWidget(startDate, null));

      // Second tap: tap June 5 (before start) — should set start=5, end=15
      final day5 = find.byWidgetPredicate((w) {
        if (w is Container && w.child is Center) {
          final text = (w.child as Center).child;
          if (text is Text && text.data == '5') return true;
        }
        return false;
      });
      await tester.tap(day5.first);
      await tester.pump();

      expect(startDate!.day, equals(5));
      expect(endDate!.day, equals(15));
    });

    testWidgets(
        'should clear range highlights when selectedRange changes to null via didUpdateWidget',
        (WidgetTester tester) async {
      DateTime? startDate = DateTime(2022, 6, 5);
      DateTime? endDate = DateTime(2022, 6, 10);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: StatefulBuilder(
              builder: (ctx, setState) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() {
                      startDate = null;
                      endDate = null;
                    }),
                    child: const Text('clear'),
                  ),
                  RangeDaysPicker(
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                    currentDate: DateTime(2022, 6, 1),
                    displayedDate: DateTime(2022, 6, 1),
                    selectedStartDate: startDate,
                    selectedEndDate: endDate,
                    theme: DatePickerPlusTheme(
                      rangePickerTheme: RangePickerTheme(
                        selectedCellsDecoration: const BoxDecoration(
                          color: Colors.deepOrange,
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
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.deepOrange),
        findsWidgets,
      );

      await tester.tap(find.text('clear'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.deepOrange),
        findsNothing,
      );
    });

    testWidgets(
        'should not call onStartDateChanged when theme isEnabled is false',
        (WidgetTester tester) async {
      DateTime? start;
      final DateTime displayedDate = DateTime(2022, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
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
            child: RangeDaysPicker(
              currentDate: displayedDate,
              minDate: DateTime(2022, 1, 1),
              maxDate: DateTime(2022, 12, 31),
              displayedDate: displayedDate,
              theme: const DatePickerPlusTheme(isEnabled: false),
              onLeadingDateTap: null,
              onEndDateChanged: (_) {},
              onStartDateChanged: (value) => start = value,
              selectedEndDate: null,
              selectedStartDate: null,
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

      expect(start, isNull);
    });

    group('onDisplayedMonthChanged', () {
      testWidgets('calls with first day of initial month on first build',
          (WidgetTester tester) async {
        final List<DateTime> calls = [];
        final DateTime displayedDate = DateTime(2022, 6, 1);

        await tester.pumpWidget(
          MaterialApp(
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: RangeDaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 12, 31),
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
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
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: RangeDaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2000, 1, 1),
                maxDate: DateTime(2030, 12, 31),
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
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
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: RangeDaysPicker(
                currentDate: displayedDate,
                displayedDate: displayedDate,
                minDate: DateTime(2000, 1, 1),
                maxDate: DateTime(2030, 12, 31),
                onStartDateChanged: (_) {},
                onEndDateChanged: (_) {},
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
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                theme = DatePickerPlusTheme.defaults(context);
                return RangeDaysPicker(
                  currentDate: displayedDate,
                  displayedDate: displayedDate,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  theme: theme,
                  onStartDateChanged: (_) {},
                  onEndDateChanged: (_) {},
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
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Material(
              child: Builder(builder: (context) {
                theme = DatePickerPlusTheme.defaults(context);
                return RangeDaysPicker(
                  currentDate: displayedDate,
                  displayedDate: displayedDate,
                  minDate: DateTime(2022, 1, 1),
                  maxDate: DateTime(2022, 12, 31),
                  theme: theme,
                  onStartDateChanged: (_) {},
                  onEndDateChanged: (_) {},
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
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
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
                      RangeDaysPicker(
                        currentDate: displayedDate,
                        displayedDate: displayedDate,
                        minDate: DateTime(2022, 1, 1),
                        maxDate: DateTime(2022, 12, 31),
                        onStartDateChanged: (_) {},
                        onEndDateChanged: (_) {},
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
