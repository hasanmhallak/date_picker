import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import '../shared/day_headers.dart';
import '../shared/picker_grid_delegate.dart';
import '../shared/utils.dart';

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class DaysView extends StatelessWidget {
  /// Displays the days of a given month and allows choosing a day.
  ///
  /// The days are arranged in a rectangular grid with one column for each day of
  /// the week.
  DaysView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.displayedMonth,
    this.selectedDate,
    this.disabledDayPredicate,
    this.cellBuilder,
    this.theme,
    this.isEnabled = true,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(() {
      if (selectedDate == null) return true;
      final min = DateTime(minDate.year, minDate.month, minDate.day);
      final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
      final selected = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
      );
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedDate;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

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

  /// A predicate function used to determine if a given day should be disabled.
  final DatePredicate? disabledDayPredicate;

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DaysPickerTheme? theme;

  /// When `false`, days are not selectable and semantics report as disabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final defaultTheme = DatePickerPlusTheme.defaults(context).daysPickerTheme;
    final contextTheme =
        Theme.of(context).extension<DatePickerPlusTheme>()?.daysPickerTheme;
    final theme = defaultTheme?.merge(contextTheme).merge(this.theme);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    final daysTheme = theme;
    final inkResponseTheme = daysTheme?.inkResponseTheme;
    final cellsPadding = daysTheme?.cellsPadding ?? EdgeInsets.zero;
    final daysOfWeekTheme = daysTheme?.daysOfTheWeekTheme;

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset =
        DateUtilsX.firstDayOffset(year, month, daysOfWeekTheme!.startOfWeek!);

    final maxDate = DateUtils.dateOnly(this.maxDate);
    final minDate = DateUtils.dateOnly(this.minDate);

    final List<Widget> dayItems =
        dayHeaders(daysOfWeekTheme, Localizations.localeOf(context));

    if (cellBuilder != null) {
      final startOfWeek = daysOfWeekTheme.startOfWeek!;
      for (int i = 0; i < dayItems.length; i++) {
        final isoWeekday = (startOfWeek - 1 + i) % 7 + 1;
        dayItems[i] = ExcludeSemantics(
          child: cellBuilder!(
            context,
            WeekDayCell(
                weekDay: isoWeekday,
                state: CellState.enabled,
                child: dayItems[i]),
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
        final bool isDateDisabled = dayToBuild.isAfter(maxDate) ||
            dayToBuild.isBefore(minDate) ||
            (disabledDayPredicate?.call(dayToBuild) ?? false);

        final bool isSelectedDay =
            DateUtils.isSameDay(selectedDate, dayToBuild);
        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);

        CellState state = CellState.enabled;
        if (isCurrent && isDateDisabled) {
          state = CellState.currentAndDisabled;
        } else if (isDateDisabled) {
          state = CellState.disabled;
        } else if (isSelectedDay) {
          state = CellState.selected;
        } else if (isCurrent) {
          state = CellState.current;
        }

        final style = daysTheme?.resolveTextStyle(state);
        final decoration = daysTheme?.resolveDecoration(state);

        Widget dayWidget = Padding(
          padding: cellsPadding,
          child: Container(
            decoration: decoration,
            child: Center(
              child: Text(
                localizations.formatDecimal(day),
                style: style,
              ),
            ),
          ),
        );

        if (cellBuilder != null) {
          dayWidget = ExcludeSemantics(
            child: cellBuilder!(context,
                DayCell(day: dayToBuild, state: state, child: dayWidget)),
          );
        }

        final String semanticLabel =
            '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}';

        if (!isEnabled) {
          dayWidget = Semantics(
            label: semanticLabel,
            selected: isSelectedDay,
            enabled: false,
            excludeSemantics: true,
            child: dayWidget,
          );
        } else if (isDateDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () => onChanged(dayToBuild),
            radius: inkResponseTheme?.radius,
            splashColor: inkResponseTheme?.splashColor,
            highlightColor: inkResponseTheme?.highlightColor,
            borderRadius: inkResponseTheme?.borderRadius,
            containedInkWell: inkResponseTheme?.containedInkWell ?? false,
            customBorder: inkResponseTheme?.customBorder,
            highlightShape: inkResponseTheme?.highlightShape ?? BoxShape.circle,
            splashFactory: inkResponseTheme?.splashFactory,
            focusColor: inkResponseTheme?.focusColor,
            hoverColor: inkResponseTheme?.hoverColor,
            child: Semantics(
              label: semanticLabel,
              selected: isSelectedDay,
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
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: PickerGridDelegate(columnCount: 7, rowCount: 7),
      childrenDelegate: SliverChildListDelegate(
        addRepaintBoundaries: false,
        dayItems,
      ),
    );
  }
}
