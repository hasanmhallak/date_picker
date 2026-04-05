import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper: build a [BuildContext] that has a full [MaterialApp] above it
/// so theme-related `.defaults()` methods work.
Widget _wrap(Widget child) => MaterialApp(home: Material(child: Scaffold(body: child)));

/// Run [fn] inside a widget test and give it a valid [BuildContext].
Future<void> _withContext(WidgetTester tester, void Function(BuildContext ctx) fn) async {
  late BuildContext captured;
  await tester.pumpWidget(
    _wrap(Builder(builder: (ctx) {
      captured = ctx;
      return const SizedBox.shrink();
    })),
  );
  fn(captured);
}

void main() {
  group('HeaderTheme', () {
    test('copyWith overrides only supplied properties', () {
      const base = HeaderTheme(enableHeader: true, enableArrowKeys: true, centerLeadingDate: false);
      final copy = base.copyWith(centerLeadingDate: true);

      expect(copy.enableHeader, isTrue);
      expect(copy.enableArrowKeys, isTrue);
      expect(copy.centerLeadingDate, isTrue);
    });

    test('copyWith overrides headerPadding and backgroundColor', () {
      const base = HeaderTheme(
        headerPadding: EdgeInsets.all(4),
        backgroundColor: Colors.red,
      );
      final copy = base.copyWith(
        headerPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.blue,
      );

      expect(copy.headerPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(16));
      expect(copy.backgroundColor, Colors.blue);
    });

    test('merge: null other returns self', () {
      const theme = HeaderTheme(enableHeader: false);
      expect(theme.merge(null), same(theme));
    });

    test('merge: other overrides all non-null properties', () {
      const a = HeaderTheme(enableHeader: true, centerLeadingDate: false);
      const b = HeaderTheme(enableHeader: false, centerLeadingDate: true);
      final merged = a.merge(b);

      expect(merged.enableHeader, isFalse);
      expect(merged.centerLeadingDate, isTrue);
    });

    test('merge: other overrides headerPadding and backgroundColor', () {
      const a = HeaderTheme(
        headerPadding: EdgeInsets.zero,
        backgroundColor: Colors.red,
      );
      const b = HeaderTheme(
        headerPadding: EdgeInsets.all(12),
        backgroundColor: Colors.teal,
      );
      final merged = a.merge(b);

      expect(merged.headerPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(12));
      expect(merged.backgroundColor, Colors.teal);
    });

    test('lerp at t=0 returns self', () {
      const a = HeaderTheme(enableHeader: true);
      const b = HeaderTheme(enableHeader: false);
      final result = a.lerp(b, 0.0);
      expect(result.enableHeader, isTrue);
    });

    test('lerp at t=1 returns other', () {
      const a = HeaderTheme(enableHeader: true);
      const b = HeaderTheme(enableHeader: false);
      final result = a.lerp(b, 1.0);
      expect(result.enableHeader, isFalse);
    });

    test('lerp interpolates headerPadding and backgroundColor', () {
      const a = HeaderTheme(
        headerPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
      );
      const b = HeaderTheme(
        headerPadding: EdgeInsets.all(20),
        backgroundColor: Colors.white,
      );
      final result = a.lerp(b, 0.5);

      expect(
        result.headerPadding?.resolve(TextDirection.ltr),
        EdgeInsetsGeometry.lerp(
          EdgeInsets.zero,
          const EdgeInsets.all(20),
          0.5,
        )?.resolve(TextDirection.ltr),
      );
      expect(result.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
    });

    test('lerp(null) returns self', () {
      const a = HeaderTheme(enableHeader: true);
      expect(a.lerp(null, 0.5), same(a));
    });

    testWidgets('defaults returns expected values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = HeaderTheme.defaults(ctx);
        expect(d.enableHeader, isTrue);
        expect(d.enableArrowKeys, isTrue);
        expect(d.centerLeadingDate, isFalse);
        expect(d.leadingDateTextStyle, isNotNull);
        expect(d.forwardArrowWidget, isNotNull);
        expect(d.backwardArrowWidget, isNotNull);
        expect(d.forwardButtonStyle, isNotNull);
        expect(d.backwardButtonStyle, isNotNull);
        expect(
          d.headerPadding?.resolve(TextDirection.ltr),
          const EdgeInsetsDirectional.only(bottom: 10.0).resolve(TextDirection.ltr),
        );
        expect(d.backgroundColor, Colors.transparent);
      });
    });
  });

  group('DaysOfTheWeekTheme', () {
    test('copyWith preserves unset fields', () {
      const base = DaysOfTheWeekTheme(startOfWeek: 1, weekdayLength: WeekdayLength.short);
      final copy = base.copyWith(startOfWeek: 7);

      expect(copy.startOfWeek, equals(7));
      expect(copy.weekdayLength, equals(WeekdayLength.short));
    });

    test('merge: null other returns self', () {
      const theme = DaysOfTheWeekTheme(startOfWeek: 1);
      expect(theme.merge(null), same(theme));
    });

    test('merge: other values override base', () {
      const a = DaysOfTheWeekTheme(startOfWeek: 1, weekdayLength: WeekdayLength.short);
      const b = DaysOfTheWeekTheme(startOfWeek: 7, weekdayLength: WeekdayLength.long);
      final m = a.merge(b);

      expect(m.startOfWeek, equals(7));
      expect(m.weekdayLength, equals(WeekdayLength.long));
    });

    test('lerp(not DaysOfTheWeekTheme) returns self', () {
      const a = DaysOfTheWeekTheme(startOfWeek: 1);
      expect(a.lerp(null, 0.5), same(a));
    });

    testWidgets('defaults returns non-null values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = DaysOfTheWeekTheme.defaults(ctx);
        expect(d.startOfWeek, isNotNull);
        expect(d.textStyle, isNotNull);
        expect(d.weekdayLength, isNotNull);
      });
    });
  });

  group('DaysPickerTheme', () {
    test('copyWith preserves unset fields', () {
      const base = DaysPickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
        disabledCellsDecoration: BoxDecoration(color: Colors.grey),
      );
      final copy = base.copyWith(disabledCellsDecoration: const BoxDecoration(color: Colors.black));

      expect((copy.enabledCellsDecoration as BoxDecoration).color, equals(Colors.red));
      expect((copy.disabledCellsDecoration as BoxDecoration).color, equals(Colors.black));
    });

    test('merge: null other returns self', () {
      const theme = DaysPickerTheme(enabledCellsDecoration: BoxDecoration(color: Colors.red));
      expect(theme.merge(null), same(theme));
    });

    test('merge: other overrides properties', () {
      const a = DaysPickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
      );
      const b = DaysPickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.blue),
      );
      final m = a.merge(b);

      expect((m.enabledCellsDecoration as BoxDecoration).color, equals(Colors.blue));
    });

    test('resolveTextStyle returns correct style for each CellState', () {
      final theme = DaysPickerTheme(
        enabledCellsTextStyle: const TextStyle(color: Colors.green),
        disabledCellsTextStyle: const TextStyle(color: Colors.grey),
        currentDateTextStyle: const TextStyle(color: Colors.blue),
        selectedCellTextStyle: const TextStyle(color: Colors.white),
      );

      expect(theme.resolveTextStyle(CellState.enabled)?.color, equals(Colors.green));
      expect(theme.resolveTextStyle(CellState.disabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.currentAndDisabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.current)?.color, equals(Colors.blue));
      expect(theme.resolveTextStyle(CellState.selected)?.color, equals(Colors.white));
    });

    test('resolveDecoration returns correct decoration for each CellState', () {
      const enabled = BoxDecoration(color: Colors.green);
      const disabled = BoxDecoration(color: Colors.grey);
      const current = BoxDecoration(color: Colors.blue);
      const selected = BoxDecoration(color: Colors.purple);

      const theme = DaysPickerTheme(
        enabledCellsDecoration: enabled,
        disabledCellsDecoration: disabled,
        currentDateDecoration: current,
        selectedCellDecoration: selected,
      );

      expect(theme.resolveDecoration(CellState.enabled), equals(enabled));
      expect(theme.resolveDecoration(CellState.disabled), equals(disabled));
      expect(theme.resolveDecoration(CellState.currentAndDisabled), equals(current));
      expect(theme.resolveDecoration(CellState.current), equals(current));
      expect(theme.resolveDecoration(CellState.selected), equals(selected));
    });

    testWidgets('defaults returns non-null values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = DaysPickerTheme.defaults(ctx);
        expect(d.enabledCellsTextStyle, isNotNull);
        expect(d.selectedCellDecoration, isNotNull);
        expect(d.daysOfTheWeekTheme, isNotNull);
        expect(d.cellsPadding?.resolve(TextDirection.ltr), EdgeInsets.zero);
      });
    });

    test('copyWith overrides cellsPadding', () {
      const base = DaysPickerTheme(cellsPadding: EdgeInsets.all(4));
      final copy = base.copyWith(cellsPadding: const EdgeInsets.all(10));
      expect(copy.cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(10));
    });

    test('merge applies other cellsPadding', () {
      const a = DaysPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = DaysPickerTheme(cellsPadding: EdgeInsets.all(8));
      expect(a.merge(b).cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(8));
    });

    test('lerp interpolates cellsPadding', () {
      const a = DaysPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = DaysPickerTheme(cellsPadding: EdgeInsets.all(20));
      final result = a.lerp(b, 0.5);
      expect(
        result.cellsPadding?.resolve(TextDirection.ltr),
        EdgeInsetsGeometry.lerp(EdgeInsets.zero, const EdgeInsets.all(20), 0.5)?.resolve(TextDirection.ltr),
      );
    });
  });

  group('MonthsPickerTheme', () {
    test('copyWith preserves unset fields', () {
      const base = MonthsPickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
        selectedCellDecoration: BoxDecoration(color: Colors.blue),
      );
      final copy = base.copyWith(
        enabledCellsDecoration: const BoxDecoration(color: Colors.green),
      );

      expect((copy.enabledCellsDecoration as BoxDecoration).color, equals(Colors.green));
      expect((copy.selectedCellDecoration as BoxDecoration).color, equals(Colors.blue));
    });

    test('merge: null other returns self', () {
      const theme = MonthsPickerTheme(enabledCellsDecoration: BoxDecoration());
      expect(theme.merge(null), same(theme));
    });

    test('merge: other overrides properties', () {
      const a = MonthsPickerTheme(selectedCellDecoration: BoxDecoration(color: Colors.red));
      const b = MonthsPickerTheme(selectedCellDecoration: BoxDecoration(color: Colors.teal));
      final m = a.merge(b);
      expect((m.selectedCellDecoration as BoxDecoration).color, equals(Colors.teal));
    });

    test('resolveTextStyle returns correct style for each CellState', () {
      final theme = MonthsPickerTheme(
        enabledCellsTextStyle: const TextStyle(color: Colors.green),
        disabledCellsTextStyle: const TextStyle(color: Colors.grey),
        currentDateTextStyle: const TextStyle(color: Colors.blue),
        selectedCellTextStyle: const TextStyle(color: Colors.white),
      );

      expect(theme.resolveTextStyle(CellState.enabled)?.color, equals(Colors.green));
      expect(theme.resolveTextStyle(CellState.disabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.currentAndDisabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.current)?.color, equals(Colors.blue));
      expect(theme.resolveTextStyle(CellState.selected)?.color, equals(Colors.white));
    });

    test('resolveDecoration returns correct decoration for each CellState', () {
      const enabled = BoxDecoration(color: Colors.green);
      const disabled = BoxDecoration(color: Colors.grey);
      const current = BoxDecoration(color: Colors.blue);
      const selected = BoxDecoration(color: Colors.teal);

      const theme = MonthsPickerTheme(
        enabledCellsDecoration: enabled,
        disabledCellsDecoration: disabled,
        currentDateDecoration: current,
        selectedCellDecoration: selected,
      );

      expect(theme.resolveDecoration(CellState.enabled), equals(enabled));
      expect(theme.resolveDecoration(CellState.disabled), equals(disabled));
      expect(theme.resolveDecoration(CellState.currentAndDisabled), equals(current));
      expect(theme.resolveDecoration(CellState.current), equals(current));
      expect(theme.resolveDecoration(CellState.selected), equals(selected));
    });

    testWidgets('defaults returns non-null values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = MonthsPickerTheme.defaults(ctx);
        expect(d.enabledCellsTextStyle, isNotNull);
        expect(d.selectedCellDecoration, isNotNull);
        expect(
          d.cellsPadding?.resolve(TextDirection.ltr),
          const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        );
      });
    });

    test('copyWith overrides cellsPadding', () {
      const base = MonthsPickerTheme(cellsPadding: EdgeInsets.all(4));
      final copy = base.copyWith(cellsPadding: const EdgeInsets.all(12));
      expect(copy.cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(12));
    });

    test('merge applies other cellsPadding', () {
      const a = MonthsPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = MonthsPickerTheme(cellsPadding: EdgeInsets.all(8));
      expect(a.merge(b).cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(8));
    });

    test('lerp interpolates cellsPadding', () {
      const a = MonthsPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = MonthsPickerTheme(cellsPadding: EdgeInsets.all(20));
      final result = a.lerp(b, 0.5);
      expect(
        result.cellsPadding?.resolve(TextDirection.ltr),
        EdgeInsetsGeometry.lerp(EdgeInsets.zero, const EdgeInsets.all(20), 0.5)?.resolve(TextDirection.ltr),
      );
    });
  });

  group('YearsPickerTheme', () {
    test('copyWith preserves unset fields', () {
      const base = YearsPickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
        selectedCellDecoration: BoxDecoration(color: Colors.blue),
      );
      final copy = base.copyWith(
        enabledCellsDecoration: const BoxDecoration(color: Colors.green),
      );

      expect((copy.enabledCellsDecoration as BoxDecoration).color, equals(Colors.green));
      expect((copy.selectedCellDecoration as BoxDecoration).color, equals(Colors.blue));
    });

    test('merge: null other returns self', () {
      const theme = YearsPickerTheme(enabledCellsDecoration: BoxDecoration());
      expect(theme.merge(null), same(theme));
    });

    test('merge: other overrides properties', () {
      const a = YearsPickerTheme(selectedCellDecoration: BoxDecoration(color: Colors.red));
      const b = YearsPickerTheme(selectedCellDecoration: BoxDecoration(color: Colors.indigo));
      final m = a.merge(b);
      expect((m.selectedCellDecoration as BoxDecoration).color, equals(Colors.indigo));
    });

    test('resolveTextStyle returns correct style for each CellState', () {
      final theme = YearsPickerTheme(
        enabledCellsTextStyle: const TextStyle(color: Colors.green),
        disabledCellsTextStyle: const TextStyle(color: Colors.grey),
        currentDateTextStyle: const TextStyle(color: Colors.blue),
        selectedCellTextStyle: const TextStyle(color: Colors.white),
      );

      expect(theme.resolveTextStyle(CellState.enabled)?.color, equals(Colors.green));
      expect(theme.resolveTextStyle(CellState.disabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.currentAndDisabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.current)?.color, equals(Colors.blue));
      expect(theme.resolveTextStyle(CellState.selected)?.color, equals(Colors.white));
    });

    test('resolveDecoration returns correct decoration for each CellState', () {
      const enabled = BoxDecoration(color: Colors.green);
      const disabled = BoxDecoration(color: Colors.grey);
      const current = BoxDecoration(color: Colors.blue);
      const selected = BoxDecoration(color: Colors.indigo);

      const theme = YearsPickerTheme(
        enabledCellsDecoration: enabled,
        disabledCellsDecoration: disabled,
        currentDateDecoration: current,
        selectedCellDecoration: selected,
      );

      expect(theme.resolveDecoration(CellState.enabled), equals(enabled));
      expect(theme.resolveDecoration(CellState.disabled), equals(disabled));
      expect(theme.resolveDecoration(CellState.currentAndDisabled), equals(current));
      expect(theme.resolveDecoration(CellState.current), equals(current));
      expect(theme.resolveDecoration(CellState.selected), equals(selected));
    });

    testWidgets('defaults returns non-null values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = YearsPickerTheme.defaults(ctx);
        expect(d.enabledCellsTextStyle, isNotNull);
        expect(d.selectedCellDecoration, isNotNull);
        expect(
          d.cellsPadding?.resolve(TextDirection.ltr),
          const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        );
      });
    });

    test('copyWith overrides cellsPadding', () {
      const base = YearsPickerTheme(cellsPadding: EdgeInsets.all(4));
      final copy = base.copyWith(cellsPadding: const EdgeInsets.all(12));
      expect(copy.cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(12));
    });

    test('merge applies other cellsPadding', () {
      const a = YearsPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = YearsPickerTheme(cellsPadding: EdgeInsets.all(8));
      expect(a.merge(b).cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(8));
    });

    test('lerp interpolates cellsPadding', () {
      const a = YearsPickerTheme(cellsPadding: EdgeInsets.zero);
      const b = YearsPickerTheme(cellsPadding: EdgeInsets.all(20));
      final result = a.lerp(b, 0.5);
      expect(
        result.cellsPadding?.resolve(TextDirection.ltr),
        EdgeInsetsGeometry.lerp(EdgeInsets.zero, const EdgeInsets.all(20), 0.5)?.resolve(TextDirection.ltr),
      );
    });
  });

  group('RangePickerTheme', () {
    test('copyWith preserves unset fields', () {
      const base = RangePickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
        disabledCellsDecoration: BoxDecoration(color: Colors.grey),
      );
      final copy = base.copyWith(disabledCellsDecoration: const BoxDecoration(color: Colors.black));

      expect((copy.enabledCellsDecoration as BoxDecoration).color, equals(Colors.red));
      expect((copy.disabledCellsDecoration as BoxDecoration).color, equals(Colors.black));
    });

    test('merge: null other returns self', () {
      const theme = RangePickerTheme(enabledCellsDecoration: BoxDecoration(color: Colors.red));
      expect(theme.merge(null), same(theme));
    });

    test('merge: other overrides properties', () {
      const a = RangePickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.red),
      );
      const b = RangePickerTheme(
        enabledCellsDecoration: BoxDecoration(color: Colors.blue),
      );
      final m = a.merge(b);

      expect((m.enabledCellsDecoration as BoxDecoration).color, equals(Colors.blue));
    });

    test('resolveTextStyle returns correct style for each CellState', () {
      final theme = RangePickerTheme(
        enabledCellsTextStyle: const TextStyle(color: Colors.green),
        disabledCellsTextStyle: const TextStyle(color: Colors.grey),
        currentDateTextStyle: const TextStyle(color: Colors.blue),
        selectedCellsTextStyle: const TextStyle(color: Colors.white),
        selectedEdgeCellTextStyle: const TextStyle(color: Colors.orange),
      );

      expect(theme.resolveTextStyle(CellState.enabled)?.color, equals(Colors.green));
      expect(theme.resolveTextStyle(CellState.disabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.currentAndDisabled)?.color, equals(Colors.grey));
      expect(theme.resolveTextStyle(CellState.current)?.color, equals(Colors.blue));
      expect(theme.resolveTextStyle(CellState.selected)?.color, equals(Colors.white));
      expect(theme.resolveTextStyle(CellState.selectedEdge)?.color, equals(Colors.orange));
    });

    test('resolveDecoration returns correct decoration for each CellState', () {
      const enabled = BoxDecoration(color: Colors.green);
      const disabled = BoxDecoration(color: Colors.grey);
      const current = BoxDecoration(color: Colors.blue);
      const selected = BoxDecoration(color: Colors.purple);
      const selectedEdge = BoxDecoration(color: Colors.orange);

      const theme = RangePickerTheme(
        enabledCellsDecoration: enabled,
        disabledCellsDecoration: disabled,
        currentDateDecoration: current,
        selectedCellsDecoration: selected,
        selectedEdgeCellDecoration: selectedEdge,
      );

      expect(theme.resolveDecoration(CellState.enabled), equals(enabled));
      expect(theme.resolveDecoration(CellState.disabled), equals(disabled));
      expect(theme.resolveDecoration(CellState.currentAndDisabled), equals(current));
      expect(theme.resolveDecoration(CellState.current), equals(current));
      expect(theme.resolveDecoration(CellState.selected), equals(selected));
      expect(theme.resolveDecoration(CellState.selectedEdge), equals(selectedEdge));
    });

    testWidgets('defaults returns non-null values', (tester) async {
      await _withContext(tester, (ctx) {
        final d = RangePickerTheme.defaults(ctx);
        expect(d.enabledCellsTextStyle, isNotNull);
        expect(d.selectedCellsDecoration, isNotNull);
        expect(d.selectedEdgeCellDecoration, isNotNull);
        expect(d.cellsPadding?.resolve(TextDirection.ltr), EdgeInsets.zero);
      });
    });

    test('copyWith overrides cellsPadding', () {
      const base = RangePickerTheme(cellsPadding: EdgeInsets.all(4));
      final copy = base.copyWith(cellsPadding: const EdgeInsets.all(10));
      expect(copy.cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(10));
    });

    test('merge applies other cellsPadding', () {
      const a = RangePickerTheme(cellsPadding: EdgeInsets.zero);
      const b = RangePickerTheme(cellsPadding: EdgeInsets.all(8));
      expect(a.merge(b).cellsPadding?.resolve(TextDirection.ltr), const EdgeInsets.all(8));
    });

    test('lerp interpolates cellsPadding', () {
      const a = RangePickerTheme(cellsPadding: EdgeInsets.zero);
      const b = RangePickerTheme(cellsPadding: EdgeInsets.all(20));
      final result = a.lerp(b, 0.5);
      expect(
        result.cellsPadding?.resolve(TextDirection.ltr),
        EdgeInsetsGeometry.lerp(EdgeInsets.zero, const EdgeInsets.all(20), 0.5)?.resolve(TextDirection.ltr),
      );
    });
  });

  group('DatePickerPlusTheme', () {
    test('copyWith preserves unset fields', () {
      const daysTheme = DaysPickerTheme(enabledCellsDecoration: BoxDecoration(color: Colors.red));
      const a = DatePickerPlusTheme(daysPickerTheme: daysTheme);
      final copy = a.copyWith();

      expect((copy.daysPickerTheme?.enabledCellsDecoration as BoxDecoration).color, equals(Colors.red));
    });

    test('merge: null other returns self', () {
      const theme = DatePickerPlusTheme();
      expect(theme.merge(null), same(theme));
    });

    test('merge: other sub-themes are merged', () {
      const a = DatePickerPlusTheme(
        daysPickerTheme: DaysPickerTheme(enabledCellsDecoration: BoxDecoration(color: Colors.red)),
      );
      const b = DatePickerPlusTheme(
        daysPickerTheme: DaysPickerTheme(enabledCellsDecoration: BoxDecoration(color: Colors.blue)),
      );
      final m = a.merge(b);
      expect((m.daysPickerTheme?.enabledCellsDecoration as BoxDecoration).color, equals(Colors.blue));
    });

    testWidgets('defaults creates non-null sub-themes', (tester) async {
      await _withContext(tester, (ctx) {
        final d = DatePickerPlusTheme.defaults(ctx);
        expect(d.daysPickerTheme, isNotNull);
        expect(d.monthsPickerTheme, isNotNull);
        expect(d.yearsPickerTheme, isNotNull);
        expect(d.rangePickerTheme, isNotNull);
        expect(d.headerTheme, isNotNull);
        expect(d.isEnabled, isTrue);
      });
    });

    test('merge: explicit isEnabled false on other wins', () {
      const a = DatePickerPlusTheme(isEnabled: true);
      const b = DatePickerPlusTheme(isEnabled: false);
      expect(a.merge(b).isEnabled, isFalse);
    });

    test('merge: null isEnabled on other keeps this', () {
      const a = DatePickerPlusTheme(isEnabled: false);
      const b = DatePickerPlusTheme();
      expect(a.merge(b).isEnabled, isFalse);
    });

    test('copyWith overrides isEnabled', () {
      const a = DatePickerPlusTheme(isEnabled: true);
      final copy = a.copyWith(isEnabled: false);
      expect(copy.isEnabled, isFalse);
    });

    test('lerp toggles isEnabled at half-open interval boundary', () {
      const a = DatePickerPlusTheme(isEnabled: true);
      const b = DatePickerPlusTheme(isEnabled: false);
      expect(a.lerp(b, 0.0).isEnabled, isTrue);
      expect(a.lerp(b, 1.0).isEnabled, isFalse);
    });
  });
}
