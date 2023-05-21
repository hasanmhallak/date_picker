import 'package:datePicker/src/header.dart';
import 'package:datePicker/src/month_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthPicker', () {
    testWidgets('should show the correct leading header date',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        find.descendant(
          of: headerFinder,
          matching: find.byType(Text),
        ),
      );
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );
    });

    testWidgets('should change the page forward and backward on drag.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
              initialDate: initialDate,
              minDate: minDate,
              maxDate: maxDate,
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
        initialDate.year.toString(),
      );
    });

    testWidgets(
        'should change the page when tapping on the next page icon and update header.',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2024, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2000, 1, 1);
      final DateTime maxDate = DateTime(2030, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        initialDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
        initialDate.year.toString(),
      );

      await tester.tap(previousPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
      final DateTime initialDate = DateTime(2022, 6, 1);
      final DateTime minDate = DateTime(2022, 1, 1);
      final DateTime maxDate = DateTime(2022, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
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
      expect(
        headerTextWidget.data,
        initialDate.year.toString(),
      );

      await tester.tap(nextPageIconFinder);
      await tester.pumpAndSettle();

      final int currentPage =
          tester.widget<PageView>(pageViewFinder).controller.page!.round();

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
      final DateTime initialDate = DateTime(2020, 6, 1);
      final DateTime minDate = DateTime(2020, 1, 1);
      final DateTime maxDate = DateTime(2020, 12, 31);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthPicker(
              initialDate: initialDate,
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
        initialDate.year.toString(),
      );
    });
  });
}
