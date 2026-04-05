import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/shared/header.dart';
import 'package:date_picker_plus/src/shared/leading_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _buildHeader({
  String displayedDate = 'June 2022',
  VoidCallback? onDateTap,
  VoidCallback? onNextPage,
  VoidCallback? onPreviousPage,
  HeaderTheme? theme,
}) {
  return MaterialApp(
    home: Material(
      child: Scaffold(
        body: Header(
          displayedDate: displayedDate,
          onDateTap: onDateTap ?? () {},
          onNextPage: onNextPage ?? () {},
          onPreviousPage: onPreviousPage ?? () {},
          theme: theme,
        ),
      ),
    ),
  );
}

void main() {
  group('Header', () {
    testWidgets('should hide everything when enableHeader is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(enableHeader: false),
        ),
      );

      expect(find.byType(LeadingDate), findsNothing);
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('should hide both arrow buttons when enableArrowKeys is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(enableArrowKeys: false),
        ),
      );

      // Leading date is still visible
      expect(find.byType(LeadingDate), findsOneWidget);
      // But no TextButton (arrow buttons) should be present
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets(
      'should center leading date when centerLeadingDate is true and enableArrowKeys is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildHeader(
            theme: const HeaderTheme(
              centerLeadingDate: true,
              enableArrowKeys: false,
            ),
          ),
        );

        final headerRect = tester.getRect(find.byType(Header));
        final leadingRect = tester.getRect(find.byType(LeadingDate));

        expect(leadingRect.center.dx, equals(headerRect.center.dx));
      },
    );

    testWidgets(
      'should use a row layout when centerLeadingDate is false and enableArrowKeys is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _buildHeader(
            theme: const HeaderTheme(
              centerLeadingDate: false,
              enableArrowKeys: false,
            ),
          ),
        );

        expect(
          find.descendant(of: find.byType(Header), matching: find.byType(Center)),
          findsNothing,
        );
        expect(
          find.descendant(of: find.byType(Header), matching: find.byType(Row)),
          findsOneWidget,
        );
      },
    );

    testWidgets('should call onDateTap when the leading date is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _buildHeader(
          onDateTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(LeadingDate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should call onNextPage when the forward button is tapped', (WidgetTester tester) async {
      bool nextPageCalled = false;

      await tester.pumpWidget(
        _buildHeader(
          onNextPage: () => nextPageCalled = true,
        ),
      );

      // The forward button is inside a Semantics with the nextPageTooltip label
      // Use TextButton finders — there are two (back and forward); tap last
      final textButtons = find.byType(TextButton);
      expect(textButtons, findsNWidgets(2));
      await tester.tap(textButtons.last);
      await tester.pump();

      expect(nextPageCalled, isTrue);
    });

    testWidgets('should call onPreviousPage when the backward button is tapped', (WidgetTester tester) async {
      bool prevPageCalled = false;

      await tester.pumpWidget(
        _buildHeader(
          onPreviousPage: () => prevPageCalled = true,
        ),
      );

      final textButtons = find.byType(TextButton);
      expect(textButtons, findsNWidgets(2));
      await tester.tap(textButtons.first);
      await tester.pump();

      expect(prevPageCalled, isTrue);
    });

    testWidgets('should place back button before leading date when centerLeadingDate is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(centerLeadingDate: true),
        ),
      );

      final backButtonOffset = tester.getTopLeft(find.byType(TextButton).first);
      final leadingDateOffset = tester.getTopLeft(find.byType(LeadingDate));

      // Back button should be to the LEFT of the leading date
      expect(backButtonOffset.dx, lessThan(leadingDateOffset.dx));
    });

    testWidgets('should place both arrows to the right of leading date when centerLeadingDate is false (default)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(centerLeadingDate: false),
        ),
      );

      final leadingDateOffset = tester.getTopLeft(find.byType(LeadingDate));
      final backButtonOffset = tester.getTopLeft(find.byType(TextButton).first);

      // Both arrow buttons grouped to the RIGHT of the leading date
      expect(backButtonOffset.dx, greaterThan(leadingDateOffset.dx));
    });

    testWidgets('should apply forwardButtonStyle to the forward button', (WidgetTester tester) async {
      final customStyle = TextButton.styleFrom(foregroundColor: Colors.red);

      await tester.pumpWidget(
        _buildHeader(
          theme: HeaderTheme(
            forwardButtonStyle: customStyle,
          ),
        ),
      );

      final textButtons = find.byType(TextButton);
      expect(textButtons, findsNWidgets(2));

      final forwardButton = tester.widget<TextButton>(textButtons.last);
      expect(forwardButton.style?.foregroundColor, customStyle.foregroundColor);
    });

    testWidgets('should apply backwardButtonStyle to the backward button', (WidgetTester tester) async {
      final customStyle = TextButton.styleFrom(foregroundColor: Colors.blue);

      await tester.pumpWidget(
        _buildHeader(
          theme: HeaderTheme(
            backwardButtonStyle: customStyle,
          ),
        ),
      );

      final textButtons = find.byType(TextButton);
      expect(textButtons, findsNWidgets(2));

      final backwardButton = tester.widget<TextButton>(textButtons.first);
      expect(backwardButton.style?.foregroundColor, customStyle.foregroundColor);
    });

    testWidgets('should display the provided displayedDate text in the leading date', (WidgetTester tester) async {
      const date = 'January 2025';

      await tester.pumpWidget(_buildHeader(displayedDate: date));

      expect(find.text(date), findsOneWidget);
    });

    testWidgets('should apply headerPadding from theme', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(
            headerPadding: customPadding,
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(LeadingDate),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, customPadding);
    });

    testWidgets('should apply decoration from theme', (WidgetTester tester) async {
      const decoration = BoxDecoration(color: Colors.lightBlue);

      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(
            decoration: decoration,
          ),
        ),
      );

      final decorated = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(Header),
          matching: find.byWidgetPredicate(
            (widget) => widget is DecoratedBox && widget.child is Padding,
          ),
        ),
      );

      expect(decorated.decoration, decoration);
    });

    testWidgets('should have correct semantic labels on arrow buttons', (WidgetTester tester) async {
      await tester.pumpWidget(_buildHeader());

      final element = tester.element(find.byType(Header));
      final localizations = MaterialLocalizations.of(element);

      expect(
        find.bySemanticsLabel(localizations.nextPageTooltip),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(localizations.previousPageTooltip),
        findsOneWidget,
      );
    });
  });
}
