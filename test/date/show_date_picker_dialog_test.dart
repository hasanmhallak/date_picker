import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showDatePickerDialog', () {
    testWidgets('should return null when dismissed by tapping the barrier',
        (WidgetTester tester) async {
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDatePickerDialog(
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

    testWidgets('should return selected date when user picks a day',
        (WidgetTester tester) async {
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDatePickerDialog(
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

      // Tap day 15
      final day15 = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            (widget.properties.label?.startsWith('15,') ?? false),
      );

      await tester.tap(day15.first);
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.day, equals(15));
      expect(result!.month, equals(6));
      expect(result!.year, equals(2022));
    });

    testWidgets('should not dismiss when barrierDismissible is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDatePickerDialog(
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
                  showDatePickerDialog(
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
                  showDatePickerDialog(
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
