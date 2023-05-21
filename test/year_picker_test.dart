import 'package:date_picker/src/header.dart';
import 'package:date_picker/src/year_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearsPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              initialDate: initialDate,
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

      expect(headerTextWidget.data, '2012 - 2023');
    });

    testWidgets('should change the page forward and backward on drag.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      const String newDisplayedMonth = '2024 - 2035';

      await tester.drag(
          pageViewFinder, const Offset(-600, 0)); // Drag the page forward
      await tester.pumpAndSettle();

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, newDisplayedMonth);

      await tester.drag(
          pageViewFinder, const Offset(600, 0)); // Drag the page backward
      await tester.pumpAndSettle();

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, '2012 - 2023');
    });

    testWidgets(
        'should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage =
          tester.widget<PageView>(pageViewFinder).controller.initialPage;

      final Finder nextPageIconFinder =
          find.byIcon(CupertinoIcons.chevron_right);
      expect(nextPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023');

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

      expect(currentPage, equals(initialPage + 1));

      const String newDisplayedMonth = '2024 - 2035';

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, newDisplayedMonth);
    });

    testWidgets(
        'should change the page when tapping on the previous page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022);
      final DateTime minDate = DateTime(2000);
      final DateTime maxDate = DateTime(2036);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearsPicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
            ),
          ),
        ),
      );

      final Finder pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      final int initialPage =
          tester.widget<PageView>(pageViewFinder).controller.initialPage;

      final Finder previousPageIconFinder =
          find.byIcon(CupertinoIcons.chevron_left);
      expect(previousPageIconFinder, findsOneWidget);

      final Finder headerFinder = find.byType(Header);
      final Text headerTextWidget = tester.widget<Text>(
          find.descendant(of: headerFinder, matching: find.byType(Text)));
      expect(headerTextWidget.data, '2012 - 2023');

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

      expect(currentPage, equals(initialPage - 1));

      const String newDisplayedMonth = '2000 - 2011';

      final Finder newHeaderFinder = find.byType(Header);
      final Text newHeaderTextWidget = tester.widget<Text>(
          find.descendant(of: newHeaderFinder, matching: find.byType(Text)));
      expect(newHeaderTextWidget.data, newDisplayedMonth);
    });

    testWidgets(
      'should NOT change the page when tapping on the previous page icon when the range in max and min date are one year.',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                initialDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller.initialPage;

        final Finder previousPageIconFinder =
            find.byIcon(CupertinoIcons.chevron_left);
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

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                initialDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder pageViewFinder = find.byType(PageView);
        expect(pageViewFinder, findsOneWidget);

        final int initialPage =
            tester.widget<PageView>(pageViewFinder).controller.initialPage;

        final Finder nextPageIconFinder =
            find.byIcon(CupertinoIcons.chevron_right);
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

        final int currentPage =
            tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                initialDate: initialDate,
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
      'Should the height of the animated container be 78 * 4',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                initialDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
              ),
            ),
          ),
        );

        final Finder animatedContainerFinder = find.byType(AnimatedContainer);
        expect(animatedContainerFinder, findsOneWidget);

        const constraints = BoxConstraints.tightFor(height: 78 * 4);

        final AnimatedContainer animatedContainerWidget =
            tester.widget<AnimatedContainer>(animatedContainerFinder);

        expect(animatedContainerWidget.constraints, equals(constraints));
      },
    );
    testWidgets(
      'Should show the correct year on pick',
      (WidgetTester tester) async {
        final DateTime initialDate = DateTime(2010);
        final DateTime minDate = DateTime(2000);
        final DateTime maxDate = DateTime(2011);
        final DateTime yearToSelect = DateTime(2010);
        late final DateTime expectedYear;
        const selectedYearColor = Colors.green;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: YearsPicker(
                initialDate: initialDate,
                minDate: minDate,
                maxDate: maxDate,
                selectedYearColor: selectedYearColor,
                selectedYearFillColor: selectedYearColor,
                onChange: (value) {
                  expectedYear = value;
                },
              ),
            ),
          ),
        );

        final selectedYearFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data ==
                    yearToSelect.year.toString() &&
                ((widget.child as Center).child as Text).style?.color ==
                    selectedYearColor;
          }
          return false;
        });

        final yearFinder = find.byWidgetPredicate((widget) {
          if (widget is Container &&
              widget.child is Center &&
              (widget.child as Center).child is Text) {
            return ((widget.child as Center).child as Text).data ==
                yearToSelect.year.toString();
          }
          return false;
        });

        expect(selectedYearFinder, findsNothing);

        await tester.tap(yearFinder);
        await tester.pumpAndSettle();

        expect(expectedYear, yearToSelect);
      },
    );
  });
}
