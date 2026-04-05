import 'package:date_picker_plus/src/range/range_selection_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeSelectionPainter', () {
    test('shouldRepaint returns true when textDirection changes', () {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: true,
      );

      final oldPainter = RangeSelectionPainter(
        textDirection: TextDirection.rtl,
        color: Colors.blue,
        start: true,
      );

      expect(painter.shouldRepaint(oldPainter), isTrue);
    });

    test('shouldRepaint returns true when color changes', () {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: true,
      );

      final oldPainter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.red,
        start: true,
      );

      expect(painter.shouldRepaint(oldPainter), isTrue);
    });

    test('shouldRepaint returns true when start flag changes', () {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: true,
      );

      final oldPainter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: false,
      );

      expect(painter.shouldRepaint(oldPainter), isTrue);
    });

    test('shouldRepaint returns false when properties are identical', () {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: true,
      );

      final oldPainter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.blue,
        start: true,
      );

      expect(painter.shouldRepaint(oldPainter), isFalse);
    });

    test('shouldRepaint returns false when color is null and matches', () {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: null,
        start: true,
      );

      final oldPainter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: null,
        start: true,
      );

      expect(painter.shouldRepaint(oldPainter), isFalse);
    });

    testWidgets('paints LTR start: rectangle on the right half', (WidgetTester tester) async {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: Colors.red,
        start: true,
      );

      // Just verify it paints without throwing.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('paints RTL start: rectangle on the left half', (WidgetTester tester) async {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.rtl,
        color: Colors.blue,
        start: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CustomPaint(painter: painter),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('paints with null color without throwing', (WidgetTester tester) async {
      final painter = RangeSelectionPainter(
        textDirection: TextDirection.ltr,
        color: null,
        start: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Scaffold(
              body: SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(painter: painter),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
