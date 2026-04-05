// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

import '../shared/cell_data.dart';
import '../shared/cell_state.dart';
import '../shared/day_headers.dart';
import '../shared/picker_grid_delegate.dart';
import '../shared/types.dart';
import '../shared/utils.dart';
import '../theme/date_picker_plus_theme.dart';

/// Displays the days of a given month and allows choosing days range.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class RangeDaysView extends StatelessWidget {
  /// Displays the days of a given month and allows choosing days range.
  ///
  /// The days are arranged in a rectangular grid with one column for each day of
  /// the week.
  RangeDaysView({
    super.key,
    required this.currentDate,
    required this.minDate,
    required this.maxDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.displayedMonth,
    this.cellBuilder,
    this.theme,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(() {
      if (selectedStartDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
      );

      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected start date should be in the range of min date & max date");
    assert(() {
      if (selectedEndDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
      );
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected end date should be in the range of min date & max date");
  }

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedEndDate;

  /// The current date. e.g (today).
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime currentDate;

  /// Called when the user picks a start date.
  final ValueChanged<DateTime> onStartDateChanged;

  /// Called when the user picks an end date.
  final ValueChanged<DateTime> onEndDateChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime maxDate;

  /// The month whose days are displayed by this picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime displayedMonth;

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DatePickerPlusTheme? theme;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final defaultTheme = DatePickerPlusTheme.defaults(context);
    final contextTheme = Theme.of(context).extension<DatePickerPlusTheme>();
    final theme = defaultTheme.merge(contextTheme).merge(this.theme);

    final bool themeEnabled = theme.isEnabled ?? true;

    final rangeTheme = theme.rangePickerTheme;
    final inkResponseTheme = rangeTheme!.inkResponseTheme;
    final cellsPadding = rangeTheme.cellsPadding ?? EdgeInsets.zero;
    final daysOfWeekTheme = theme.daysPickerTheme?.daysOfTheWeekTheme;

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(displayedMonth.year, displayedMonth.month);

    final int dayOffset =
        DateUtilsX.firstDayOffset(displayedMonth.year, displayedMonth.month, daysOfWeekTheme!.startOfWeek!);

    DateTime? selectedEndDateOnly = selectedEndDate != null ? DateUtils.dateOnly(selectedEndDate!) : null;

    DateTime? selectedStartDateOnly = selectedStartDate != null ? DateUtils.dateOnly(selectedStartDate!) : null;

    final maxDate = DateUtils.dateOnly(this.maxDate);
    final minDate = DateUtils.dateOnly(this.minDate);

    final List<Widget> dayItems = dayHeaders(daysOfWeekTheme, Localizations.localeOf(context));

    if (cellBuilder != null) {
      final startOfWeek = daysOfWeekTheme.startOfWeek!;
      for (int i = 0; i < dayItems.length; i++) {
        final isoWeekday = (startOfWeek - 1 + i) % 7 + 1;
        dayItems[i] = ExcludeSemantics(
          child: cellBuilder!(
            context,
            WeekDayCell(weekDay: isoWeekday, state: CellState.enabled, child: dayItems[i]),
          ),
        );
      }
    }

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDateDisabled = dayToBuild.isAfter(maxDate) || dayToBuild.isBefore(minDate);

        final isRangeSelected = selectedStartDateOnly != null && selectedEndDateOnly != null;

        final isStartSelectedOnly =
            selectedStartDateOnly != null && dayToBuild == selectedStartDateOnly && selectedEndDateOnly == null;

        final isEndSelectedOnly =
            selectedStartDateOnly == null && selectedEndDateOnly != null && dayToBuild == selectedEndDateOnly;

        final isRangeOnlyOneDate = selectedStartDateOnly == selectedEndDateOnly && dayToBuild == selectedStartDateOnly;

        final isSingleCellSelected = isStartSelectedOnly || isEndSelectedOnly || isRangeOnlyOneDate;

        final bool isWithinRange = isRangeSelected &&
            dayToBuild.isAfter(selectedStartDateOnly) &&
            dayToBuild.isBefore(selectedEndDateOnly) &&
            !isRangeOnlyOneDate;

        final isStartDate = DateUtils.isSameDay(selectedStartDateOnly, dayToBuild);

        final isEndDate = DateUtils.isSameDay(selectedEndDateOnly, dayToBuild);

        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);

        CellState state = CellState.enabled;
        if (isCurrent && isDateDisabled) {
          state = CellState.currentAndDisabled;
        } else if (isDateDisabled) {
          state = CellState.disabled;
        } else if (isSingleCellSelected || isStartDate || isEndDate) {
          state = CellState.selectedEdge;
        } else if (isWithinRange) {
          state = CellState.selected;
        } else if (isCurrent) {
          state = CellState.current;
        }

        final style = rangeTheme.resolveTextStyle(state);
        final decoration = rangeTheme.resolveDecoration(state);

        Widget dayWidget = Padding(
          padding: cellsPadding,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: decoration,
            child: Center(
              child: Text(
                localizations.formatDecimal(day),
                style: style,
              ),
            ),
          ),
        );

        if ((isStartDate || isEndDate) && isRangeSelected && !isRangeOnlyOneDate) {
          Color? decorationColor;
          final resolvedDecoration = rangeTheme.resolveDecoration(CellState.selected);

          // if any other implementation of Decoration is added, the user must update the resolvePainter method.
          if (resolvedDecoration case ShapeDecoration(color: final color) || BoxDecoration(color: final color)) {
            decorationColor = color;
          }

          dayWidget = CustomPaint(
            painter: rangeTheme.resolvePainter?.call(Directionality.of(context), decorationColor, isStartDate),
            child: dayWidget,
          );
        }

        if (cellBuilder != null) {
          dayWidget = ExcludeSemantics(
            child: cellBuilder!(context, DayCell(day: dayToBuild, state: state, child: dayWidget)),
          );
        }

        String semanticLabel = '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}';
        if (isStartDate) {
          semanticLabel = localizations.dateRangeStartDateSemanticLabel(semanticLabel);
        } else if (isEndDate) {
          semanticLabel = localizations.dateRangeEndDateSemanticLabel(semanticLabel);
        }

        if (!themeEnabled) {
          dayWidget = Semantics(
            label: semanticLabel,
            selected: isSingleCellSelected || isStartDate || isEndDate || isWithinRange,
            enabled: false,
            excludeSemantics: true,
            child: dayWidget,
          );
        } else if (isDateDisabled) {
          dayWidget = ExcludeSemantics(child: dayWidget);
        } else {
          dayWidget = InkResponse(
            onTap: () {
              final isStart = (selectedEndDate == null && selectedStartDate == null) ||
                  (selectedEndDate != null && selectedStartDate != null);

              if (isStart) {
                onStartDateChanged(dayToBuild);
                return;
              }

              if (dayToBuild.isBefore(selectedStartDate!)) {
                onStartDateChanged(dayToBuild);
                onEndDateChanged(selectedStartDate!);
                return;
              }

              onEndDateChanged(dayToBuild);
            },
            radius: inkResponseTheme?.radius,
            splashColor: inkResponseTheme?.splashColor ?? Colors.transparent,
            highlightColor: inkResponseTheme?.highlightColor ?? Colors.transparent,
            borderRadius: inkResponseTheme?.borderRadius,
            containedInkWell: inkResponseTheme?.containedInkWell ?? false,
            customBorder: inkResponseTheme?.customBorder,
            highlightShape: inkResponseTheme?.highlightShape ?? BoxShape.circle,
            splashFactory: inkResponseTheme?.splashFactory,
            focusColor: inkResponseTheme?.focusColor,
            hoverColor: inkResponseTheme?.hoverColor,
            child: Semantics(
              label: semanticLabel,
              selected: isSingleCellSelected || isStartDate || isEndDate || isWithinRange,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(columnCount: 7, rowCount: 7),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}
