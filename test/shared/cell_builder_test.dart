import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:date_picker_plus/src/date/days_view.dart';
import 'package:date_picker_plus/src/range/range_days_view.dart';
import 'package:date_picker_plus/src/shared/month_view.dart';
import 'package:date_picker_plus/src/shared/year_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DaysView cellBuilder', () {
    testWidgets('receives DayCell with correct date, state, and bare widget',
        (WidgetTester tester) async {
      final List<CellData> recorded = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              selectedDate: DateTime(2020, 1, 15),
              cellBuilder: (context, data) {
                recorded.add(data);
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final dayCells = recorded.whereType<DayCell>().toList();
      expect(dayCells.length, 31);

      final day15 = dayCells.firstWhere((c) => c.day.day == 15);
      expect(day15.state, CellState.selected);

      final day10 = dayCells.firstWhere((c) => c.day.day == 10);
      expect(day10.state, CellState.current);

      final day1 = dayCells.firstWhere((c) => c.day.day == 1);
      expect(day1.state, CellState.enabled);
    });

    testWidgets('child widget is bare (no InkResponse or Semantics)',
        (WidgetTester tester) async {
      late Widget capturedChild;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                if (data is DayCell && data.day.day == 5) {
                  capturedChild = data.child;
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(capturedChild, isA<Padding>());
      expect(capturedChild, isNot(isA<InkResponse>()));
      expect(capturedChild, isNot(isA<Semantics>()));
    });

    testWidgets('tapping still fires onChanged when cellBuilder is provided',
        (WidgetTester tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (date) => selected = date,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(31));

      await tester.tap(inkResponses.at(3));
      expect(selected, DateTime(2020, 1, 4));
    });

    testWidgets('marker widget from cellBuilder is present in the tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                if (data is! DayCell) return data.child;
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(31));
    });

    testWidgets('disabled day still receives correct state and is not tappable',
        (WidgetTester tester) async {
      CellState? disabledState;
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (_) => tapped = true,
              minDate: DateTime(2020, 1, 5),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                if (data is DayCell && data.day.day == 2) {
                  disabledState = data.state;
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(disabledState, CellState.disabled);

      final disabledCell = find.text('2');

      expect(disabledCell, findsOneWidget);
      await tester.tap(disabledCell, warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
    });
  });

  group('DaysView weekday headers cellBuilder', () {
    testWidgets('receives WeekDayCell with correct weekDay values',
        (WidgetTester tester) async {
      final List<WeekDayCell> weekDayCells = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: DaysView(
              currentDate: DateTime(2020, 1, 10),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                if (data is WeekDayCell) {
                  weekDayCells.add(data);
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(weekDayCells.length, 7);

      for (final cell in weekDayCells) {
        expect(cell.weekDay, inInclusiveRange(1, 7));
        expect(cell.state, CellState.enabled);
      }

      final weekDays = weekDayCells.map((c) => c.weekDay).toSet();
      expect(weekDays.length, 7);
    });
  });

  group('MonthView cellBuilder', () {
    testWidgets('receives MonthCell with correct month, year, and state',
        (WidgetTester tester) async {
      final List<CellData> recorded = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 5, 1),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 12, 1),
              displayedDate: DateTime(2020, 1, 1),
              selectedDate: DateTime(2020, 3, 1),
              cellBuilder: (context, data) {
                recorded.add(data);
                return data.child;
              },
            ),
          ),
        ),
      );

      final monthCells = recorded.whereType<MonthCell>().toList();
      expect(monthCells.length, 12);

      final march = monthCells.firstWhere((c) => c.month == 3);
      expect(march.year, 2020);
      expect(march.state, CellState.selected);

      final may = monthCells.firstWhere((c) => c.month == 5);
      expect(may.state, CellState.current);

      final june = monthCells.firstWhere((c) => c.month == 6);
      expect(june.state, CellState.enabled);
    });

    testWidgets('child widget is bare (no InkResponse or Semantics)',
        (WidgetTester tester) async {
      late Widget capturedChild;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 5, 1),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 12, 1),
              displayedDate: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                if (data is MonthCell && data.month == 6) {
                  capturedChild = data.child;
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(capturedChild, isA<Padding>());
      expect(capturedChild, isNot(isA<InkResponse>()));
      expect(capturedChild, isNot(isA<Semantics>()));
    });

    testWidgets('tapping still fires onChanged when cellBuilder is provided',
        (WidgetTester tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 5, 1),
              onChanged: (date) => selected = date,
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 12, 1),
              displayedDate: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(12));

      await tester.tap(inkResponses.at(1));
      expect(selected, DateTime(2020, 2));
    });

    testWidgets('marker widget from cellBuilder is present in the tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MonthView(
              currentDate: DateTime(2020, 5, 1),
              onChanged: (_) {},
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 12, 1),
              displayedDate: DateTime(2020, 1, 1),
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(12));
    });
  });

  group('YearView cellBuilder', () {
    testWidgets('receives YearCell with correct year and state',
        (WidgetTester tester) async {
      final List<CellData> recorded = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (_) {},
              minDate: DateTime(2017),
              maxDate: DateTime(2028),
              displayedYearRange:
                  DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              selectedDate: DateTime(2022),
              cellBuilder: (context, data) {
                recorded.add(data);
                return data.child;
              },
            ),
          ),
        ),
      );

      final yearCells = recorded.whereType<YearCell>().toList();
      expect(yearCells.length, 12);

      final year2022 = yearCells.firstWhere((c) => c.year == 2022);
      expect(year2022.state, CellState.selected);

      final year2020 = yearCells.firstWhere((c) => c.year == 2020);
      expect(year2020.state, CellState.current);

      final year2021 = yearCells.firstWhere((c) => c.year == 2021);
      expect(year2021.state, CellState.enabled);
    });

    testWidgets('child widget is bare (no InkResponse or Semantics)',
        (WidgetTester tester) async {
      late Widget capturedChild;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (_) {},
              minDate: DateTime(2017),
              maxDate: DateTime(2028),
              displayedYearRange:
                  DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              cellBuilder: (context, data) {
                if (data is YearCell && data.year == 2021) {
                  capturedChild = data.child;
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(capturedChild, isA<Padding>());
      expect(capturedChild, isNot(isA<InkResponse>()));
      expect(capturedChild, isNot(isA<Semantics>()));
    });

    testWidgets('tapping still fires onChanged when cellBuilder is provided',
        (WidgetTester tester) async {
      DateTime? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (date) => selected = date,
              minDate: DateTime(2017),
              maxDate: DateTime(2028),
              displayedYearRange:
                  DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(12));

      await tester.tap(inkResponses.at(4));
      expect(selected, DateTime(2021));
    });

    testWidgets('marker widget from cellBuilder is present in the tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: YearView(
              currentDate: DateTime(2020),
              onChanged: (_) {},
              minDate: DateTime(2017),
              maxDate: DateTime(2028),
              displayedYearRange:
                  DateTimeRange(start: DateTime(2017), end: DateTime(2028)),
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(12));
    });
  });

  group('RangeDaysView cellBuilder', () {
    testWidgets('receives DayCell with correct date and state',
        (WidgetTester tester) async {
      final List<CellData> recorded = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: DateTime(2020, 1, 10),
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              selectedStartDate: DateTime(2020, 1, 5),
              selectedEndDate: DateTime(2020, 1, 15),
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
              cellBuilder: (context, data) {
                recorded.add(data);
                return data.child;
              },
            ),
          ),
        ),
      );

      final dayCells = recorded.whereType<DayCell>().toList();
      expect(dayCells.length, 31);

      final day5 = dayCells.firstWhere((c) => c.day.day == 5);
      expect(day5.state, CellState.selectedEdge);

      final day15 = dayCells.firstWhere((c) => c.day.day == 15);
      expect(day15.state, CellState.selectedEdge);

      final day8 = dayCells.firstWhere((c) => c.day.day == 8);
      expect(day8.state, CellState.selected);

      final day20 = dayCells.firstWhere((c) => c.day.day == 20);
      expect(day20.state, CellState.enabled);
    });

    testWidgets('child widget is bare (no InkResponse or Semantics)',
        (WidgetTester tester) async {
      late Widget capturedChild;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: DateTime(2020, 1, 10),
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              selectedStartDate: null,
              selectedEndDate: null,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
              cellBuilder: (context, data) {
                if (data is DayCell && data.day.day == 5) {
                  capturedChild = data.child;
                }
                return data.child;
              },
            ),
          ),
        ),
      );

      expect(capturedChild, isA<Padding>());
      expect(capturedChild, isNot(isA<InkResponse>()));
      expect(capturedChild, isNot(isA<Semantics>()));
    });

    testWidgets(
        'tapping still fires start/end date callbacks when cellBuilder is provided',
        (WidgetTester tester) async {
      DateTime? startDate;
      DateTime? endDate;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: DateTime(2020, 1, 10),
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              selectedStartDate: null,
              selectedEndDate: null,
              onStartDateChanged: (date) => startDate = date,
              onEndDateChanged: (date) => endDate = date,
              cellBuilder: (context, data) {
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final inkResponses = find.byType(InkResponse);
      expect(inkResponses, findsNWidgets(31));

      await tester.tap(inkResponses.at(4));
      expect(startDate, DateTime(2020, 1, 5));
      expect(endDate, isNull);
    });

    testWidgets('marker widget from cellBuilder is present in the tree',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: RangeDaysView(
              currentDate: DateTime(2020, 1, 10),
              minDate: DateTime(2020, 1, 1),
              maxDate: DateTime(2020, 1, 31),
              displayedMonth: DateTime(2020, 1, 1),
              selectedStartDate: null,
              selectedEndDate: null,
              onStartDateChanged: (_) {},
              onEndDateChanged: (_) {},
              cellBuilder: (context, data) {
                if (data is! DayCell) return data.child;
                return Stack(
                  children: [
                    data.child,
                    const Icon(Icons.star),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsNWidgets(31));
    });
  });
}
