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
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    this.selectedDate,
    required this.displayedMonth,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disbaledCellsTextStyle,
    required this.disbaledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
  })  : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate"),
        assert(() {
          if (selectedDate == null) return true;
          return (selectedDate.isAfter(minDate) ||
                  selectedDate.isAtSameMomentAs(minDate)) &&
              (selectedDate.isBefore(maxDate) ||
                  selectedDate.isAtSameMomentAs(maxDate));
        }(), "selected date should be in the range of min date & max date");

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDate;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

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

  /// The text style of the days name.
  final TextStyle daysOfTheWeekTextStyle;

  /// The text style of days which are selectable.
  final TextStyle enabledCellsTextStyle;

  /// The cell decoration of days which are selectable.
  final BoxDecoration enabledCellsDecoration;

  /// The text style of days which are not selectable.
  final TextStyle disbaledCellsTextStyle;

  /// The cell decoration of days which are not selectable.
  final BoxDecoration disbaledCellsDecoration;

  /// The text style of the current day
  final TextStyle currentDateTextStyle;

  /// The cell decoration of the current day.
  final BoxDecoration currentDateDecoration;

  /// The text style of selected day.
  final TextStyle selectedDayTextStyle;

  /// The cell decoration of selected day.
  final BoxDecoration selectedDayDecoration;

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
        final bool isSelectedDay =
            DateUtils.isSameDay(selectedDate, dayToBuild);

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

        if (isSelectedDay) {
          //
          //
          style = selectedDayTextStyle;
          decoration = selectedDayDecoration;
        }

        if (isDisabled) {
          style = disbaledCellsTextStyle;
          decoration = disbaledCellsDecoration;
        }

        if (isCurrent && isDisabled) {
          //
          //
          style = disbaledCellsTextStyle;
          decoration = currentDateDecoration;
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Text(
              localizations.formatDecimal(day),
              style: style,
            ),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () => onChanged(dayToBuild),
            radius: splashRadius ?? _dayPickerRowHeight / 2 + 4,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(
        columnCount: DateTime.daysPerWeek,
        columnPadding: 4,
        rowPadding: 4,
        rowExtent: _dayPickerRowHeight,
        rowStride: _dayPickerRowHeight,
      ),
      childrenDelegate: SliverChildListDelegate(
        addRepaintBoundaries: false,
        dayItems,
      ),
    );
  }
}
