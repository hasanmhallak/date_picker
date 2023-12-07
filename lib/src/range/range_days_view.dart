import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

import '../shared/picker_grid_delegate.dart';

const double _dayPickerRowHeight = 52.0;

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
    required this.minDate,
    required this.maxDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.displayedMonth,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disbaledCellsTextStyle,
    required this.disbaledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedCellsTextStyle,
    required this.selectedCellsDecoration,
    required this.selectedStartCellTextStyle,
    required this.selectedStartCellDecoration,
    required this.selectedEndCellTextStyle,
    required this.selectedEndCellDecoration,
    required this.singelSelectedCellTextStyle,
    required this.singelSelectedCellDecoration,
    required this.highlightColor,
    required this.splashColor,
    required this.splashRadius,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker
  final DateTime? selectedEndDate;

  /// The current date. e.g (today)
  final DateTime currentDate;

  /// Called when the user picks a start date.
  final ValueChanged<DateTime> onStartDateChanged;

  /// Called when the user picks an end date.
  final ValueChanged<DateTime> onEndDateChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// The text style of the week days name.
  final TextStyle daysOfTheWeekTextStyle;

  /// The text style of cells which are selectable.
  final TextStyle enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  final TextStyle disbaledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  final BoxDecoration disbaledCellsDecoration;

  /// The text style of selected start cell of the range.
  final TextStyle selectedStartCellTextStyle;

  /// The cell decoration of selected start cell of the range.
  final BoxDecoration selectedStartCellDecoration;

  /// The text style of selected end cell of the range.
  final TextStyle selectedEndCellTextStyle;

  /// The cell decoration of selected end cell of the range.
  final BoxDecoration selectedEndCellDecoration;

  /// The text style of a single selected cell.
  final TextStyle singelSelectedCellTextStyle;

  /// The cell decoration of a single selected cell.
  final BoxDecoration singelSelectedCellDecoration;

  /// The text style of the current date.
  final TextStyle currentDateTextStyle;

  /// The cell decoration of the current date.
  final BoxDecoration currentDateDecoration;

  /// The text style of selected cells in a range.
  final TextStyle selectedCellsTextStyle;

  /// The cell decoration of selected cells in a range.
  final BoxDecoration selectedCellsDecoration;

  /// The splash color of the ink response.
  final Color splashColor;

  /// The highlight color of the ink response when pressed.
  final Color highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  ///     ┌ Sunday is the first day of week in the US (en_US)
  ///     |
  ///     S M T W T F S  ← the returned list contains these widgets
  ///     _ _ _ _ _ 1 2
  ///     3 4 5 6 7 8 9
  ///
  ///     ┌ But it's Monday in the UK (en_GB)
  ///     |
  ///     M T W T F S S  ← the returned list contains these widgets
  ///     _ _ _ _ 1 2 3
  ///     4 5 6 7 8 9 10
  ///
  List<Widget> _dayHeaders(
    TextStyle headerStyle,
    Locale locale,
    MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    final weekdayNames =
        intl.DateFormat('', locale.toString()).dateSymbols.SHORTWEEKDAYS;

    // Monday is represented by 1 and Sunday is represented by 7.
    // but MaterialLocalizations does not have 7 instead the sunday is 0.
    // final int todayIndex = currentDate.weekday == 7 ? 0 : currentDate.weekday;
    // TODO: add custom firstDayOfWeekIndex.
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      // to save space in arabic as arabic don't has short week days.
      final String weekday = weekdayNames[i].replaceFirst('ال', '');
      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday.toUpperCase(),
              style: daysOfTheWeekTextStyle,
            ),
          ),
        ),
      );
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    //
    //
    //
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(
      daysOfTheWeekTextStyle,
      Localizations.localeOf(context),
      MaterialLocalizations.of(context),
    );

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled =
            dayToBuild.isAfter(maxDate) || dayToBuild.isBefore(minDate);

        final isRangeSelected =
            selectedStartDate != null && selectedEndDate != null;

        final isSingleCellSelected = (selectedStartDate != null &&
                selectedEndDate == null &&
                dayToBuild == selectedStartDate) &&
            !isRangeSelected;

        final bool isWithinRange = isRangeSelected &&
            dayToBuild.isAfter(selectedStartDate!) &&
            dayToBuild.isBefore(selectedEndDate!);

        final isStartDate = DateUtils.isSameDay(selectedStartDate, dayToBuild);

        final isEndDate = DateUtils.isSameDay(selectedEndDate, dayToBuild);

        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);
        //
        //
        BoxDecoration decoration = enabledCellsDecoration;
        TextStyle style = enabledCellsTextStyle;

        if (isCurrent) {
          //
          //
          style = currentDateTextStyle;
          decoration = currentDateDecoration;
        }

        if (isStartDate) {
          //
          //
          style = selectedStartCellTextStyle;
          decoration = selectedStartCellDecoration;
        }
        if (isEndDate) {
          //
          //
          style = selectedEndCellTextStyle;
          decoration = selectedEndCellDecoration;
        }

        if (isSingleCellSelected) {
          //
          //
          style = singelSelectedCellTextStyle;
          decoration = singelSelectedCellDecoration;
        }
        if (isWithinRange) {
          //
          //
          style = selectedCellsTextStyle;
          decoration = selectedCellsDecoration;
        }

        if (isDisabled) {
          //
          //
          style = disbaledCellsTextStyle;
          decoration = disbaledCellsDecoration;
        }

        if (isCurrent && isDisabled) {
          //
          //
          style = disbaledCellsTextStyle;
          decoration = currentDateDecoration;
        }

        Widget dayWidget = Center(
          child: Text(
            localizations.formatDecimal(day),
            style: style,
          ),
        );

        if (isStartDate || isEndDate) {
          dayWidget = Container(
            clipBehavior: Clip.hardEdge,
            decoration: singelSelectedCellDecoration,
            child: dayWidget,
          );
        }

        dayWidget = Container(
          decoration: decoration,
          child: dayWidget,
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () {
              final isStart =
                  (selectedEndDate == null && selectedStartDate == null) ||
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

              if (dayToBuild == selectedStartDate) {
                return;
              }

              onEndDateChanged(dayToBuild);
            },
            radius: splashRadius ?? _dayPickerRowHeight / 2 + 4,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(
        columnCount: DateTime.daysPerWeek,
        columnPadding: 0,
        rowPadding: 3,
        rowExtent: _dayPickerRowHeight,
        rowStride: _dayPickerRowHeight,
      ),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}
