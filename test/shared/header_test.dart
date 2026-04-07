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
      expect(find.byType(InkResponse), findsNothing);
    });

    testWidgets('should hide both arrow buttons when enableArrowKeys is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(enableArrowKeys: false),
        ),
      );

      // Leading date is still visible
      expect(find.byType(LeadingDate), findsOneWidget);
      expect(find.byType(InkResponse), findsNothing);
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

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(2));
      await tester.tap(inkResponses.last);
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

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(2));
      await tester.tap(inkResponses.first);
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

      final backInkOffset = tester.getTopLeft(find.byType(InkResponse).first);
      final leadingDateOffset = tester.getTopLeft(find.byType(LeadingDate));

      expect(backInkOffset.dx, lessThan(leadingDateOffset.dx));
    });

    testWidgets('should place both arrows to the right of leading date when centerLeadingDate is false (default)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(centerLeadingDate: false),
        ),
      );

      final leadingDateOffset = tester.getTopLeft(find.byType(LeadingDate));
      final backInkOffset = tester.getTopLeft(find.byType(InkResponse).first);

      expect(backInkOffset.dx, greaterThan(leadingDateOffset.dx));
    });

    testWidgets('should apply forwardButtonDecoration to the forward arrow button', (WidgetTester tester) async {
      const decoration = ShapeDecoration(color: Colors.red, shape: CircleBorder());

      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(
            forwardButtonDecoration: decoration,
          ),
        ),
      );

      final forwardInk = find.byType(InkResponse).last;
      final container = tester.widget<Ink>(
        find.ancestor(of: forwardInk, matching: find.byType(Ink)),
      );
      expect(container.decoration, decoration);
      expect(tester.widget<InkResponse>(forwardInk).customBorder, decoration.shape);
    });

    testWidgets('should apply backwardButtonDecoration to the backward arrow button', (WidgetTester tester) async {
      const decoration = ShapeDecoration(color: Colors.blue, shape: CircleBorder());

      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(
            backwardButtonDecoration: decoration,
          ),
        ),
      );

      final backwardInk = find.byType(InkResponse).first;
      final container = tester.widget<Ink>(
        find.ancestor(of: backwardInk, matching: find.byType(Ink)),
      );
      expect(container.decoration, decoration);
    });

    testWidgets('should apply arrowButtonsSpace between backward and forward arrow buttons', (WidgetTester tester) async {
      const space = 24.0;

      await tester.pumpWidget(
        _buildHeader(
          theme: const HeaderTheme(arrowButtonsSpace: space),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(Header),
          matching: find.byWidgetPredicate(
            (w) => w is SizedBox && w.width == space,
          ),
        ),
      );
      expect(sizedBox.width, space);
    });

    testWidgets('should apply forwardButtonInkResponseTheme splash to forward InkResponse',
        (WidgetTester tester) async {
      const customSplash = Colors.red;

      await tester.pumpWidget(
        _buildHeader(
          theme: HeaderTheme(
            forwardButtonInkResponseTheme: InkResponseTheme(
              splashColor: customSplash,
              highlightColor: Colors.transparent,
            ),
          ),
        ),
      );

      final forwardInk = tester.widget<InkResponse>(find.byType(InkResponse).last);
      expect(forwardInk.splashColor, customSplash);
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
            (widget) => widget is DecoratedBox && widget.decoration == decoration,
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
