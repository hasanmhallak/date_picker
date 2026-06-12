import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showRangePickerDialog', () {
    testWidgets('should return null when dismissed by tapping the barrier',
        (WidgetTester tester) async {
      DateTimeRange? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showRangePickerDialog(
                    context: context,
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Tap outside the dialog (barrier)
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets(
        'should return selected range when user picks start and end dates',
        (WidgetTester tester) async {
      DateTimeRange? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showRangePickerDialog(
                    context: context,
                    minDate: DateTime(2022, 6, 1),
                    maxDate: DateTime(2022, 6, 30),
                    displayedDate: DateTime(2022, 6, 1),
                    currentDate: DateTime(2022, 6, 1),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Tap day 5 (start)
      final day5 = find.byWidgetPredicate(
        (w) =>
            w is Semantics && (w.properties.label?.startsWith('5,') ?? false),
      );
      await tester.tap(day5.first);
      await tester.pump();

      // Tap day 10 (end)
      final day10 = find.byWidgetPredicate(
        (w) =>
            w is Semantics && (w.properties.label?.startsWith('10,') ?? false),
      );
      await tester.tap(day10.first);
      await tester.pumpAndSettle();

      // Dialog should have closed (Navigator.pop called with range)
      expect(find.byType(Dialog), findsNothing);
      expect(result, isNotNull);
      expect(result!.start.day, equals(5));
      expect(result!.start.month, equals(6));
      expect(result!.start.year, equals(2022));
      expect(result!.end.day, equals(10));
      expect(result!.end.month, equals(6));
      expect(result!.end.year, equals(2022));
    });

    testWidgets('should not dismiss when barrierDismissible is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showRangePickerDialog(
                    context: context,
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                    barrierDismissible: false,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Dialog is visible
      expect(find.byType(Dialog), findsOneWidget);

      // Tap outside — should NOT close
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets(
        'should use provided initialPickerType to show MonthPicker first',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showRangePickerDialog(
                    context: context,
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                    initialPickerType: PickerType.months,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(MonthPicker), findsOneWidget);
    });

    testWidgets('should apply dialogBackground to the dialog',
        (WidgetTester tester) async {
      const dialogBackground = Colors.amber;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showRangePickerDialog(
                    context: context,
                    minDate: DateTime(2022, 1, 1),
                    maxDate: DateTime(2022, 12, 31),
                    dialogBackground: dialogBackground,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final dialog = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialog.backgroundColor, equals(dialogBackground));
    });
  });
}
