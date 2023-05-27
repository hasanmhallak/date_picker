import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'picker_grid_delegate.dart';

/// Displays the months of a given year and allows choosing a month.
///
/// Months are arranged in a rectangular grid with tree columns.
class MonthView extends StatelessWidget {
  /// Displays the months of a given year and allows choosing a month.
  ///
  /// Months are arranged in a rectangular grid with tree columns.
  MonthView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.displayedYear,
    required this.enabledMonthTextStyle,
    required this.enabledMonthDecoration,
    required this.disbaledMonthTextStyle,
    required this.disbaledMonthDecoration,
    required this.currentMonthTextStyle,
    required this.currentMonthDecoration,
    required this.selectedMonthTextStyle,
    required this.selectedMonthDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
    this.selectedMonth,
  })  : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate"),
        assert(() {
          if (selectedMonth == null) return true;
          return selectedMonth.isAfter(minDate) &&
              selectedMonth.isBefore(maxDate);
        }(), "selected date should be in the range of min date & max date");

  /// The currently selected month.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedMonth;

  /// The current month at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The year which its months are displayed by this picker.
  final DateTime displayedYear;

  /// The text style of months which are selectable.
  final TextStyle enabledMonthTextStyle;

  /// The cell decoration of months which are selectable.
  final BoxDecoration enabledMonthDecoration;

  /// The text style of months which are not selectable.
  final TextStyle disbaledMonthTextStyle;

  /// The cell decoration of months which are not selectable.
  final BoxDecoration disbaledMonthDecoration;

  /// The text style of the current month
  final TextStyle currentMonthTextStyle;

  /// The cell decoration of the current month.
  final BoxDecoration currentMonthDecoration;

  /// The text style of selected month.
  final TextStyle selectedMonthTextStyle;

  /// The cell decoration of selected month.
  final BoxDecoration selectedMonthDecoration;

  /// The splash color of the ink response.
  final Color splashColor;

  /// The highlight color of the ink response when pressed.
  final Color highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final int year = displayedYear.year;
    // we git rid of the day because if there is anu day allowed in
    // in the month we should not gray it out.
    final DateTime startMonth = DateTime(minDate.year, minDate.month);
    final DateTime endMonth = DateTime(maxDate.year, maxDate.month);
    DateTime? selectedMonth;
    if (this.selectedMonth != null) {
      selectedMonth =
          DateTime(this.selectedMonth!.year, this.selectedMonth!.month);
    }

    final monthsNames =
        DateFormat('', locale.toString()).dateSymbols.STANDALONESHORTMONTHS;
    final monthsWidgetList = <Widget>[];

    int month = 0;
    while (month < 12) {
      final DateTime monthToBuild = DateTime(year, month + 1);

      final bool isDisabled =
          monthToBuild.isAfter(endMonth) || monthToBuild.isBefore(startMonth);

      final bool isCurrentMonth =
          monthToBuild == DateTime(currentDate.year, currentDate.month);

      final bool isSelected = monthToBuild == selectedMonth;
      //
      //
      BoxDecoration decoration = enabledMonthDecoration;
      TextStyle style = enabledMonthTextStyle;

      if (isCurrentMonth) {
        //
        //
        style = currentMonthTextStyle;
        decoration = currentMonthDecoration;
      }
      if (isSelected) {
        //
        //
        style = selectedMonthTextStyle;
        decoration = selectedMonthDecoration;
      }

      if (isDisabled) {
        style = disbaledMonthTextStyle;
        decoration = disbaledMonthDecoration;
      }

      Widget monthWidget = Container(
        decoration: decoration,
        child: Center(
          child: Text(
            monthsNames[month],
            style: style,
          ),
        ),
      );

      if (isDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        monthWidget = InkResponse(
          onTap: () => onChanged(monthToBuild),
          radius: splashRadius ?? 60 / 2 + 4,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Semantics(
            label: localizations.formatMediumDate(monthToBuild),
            selected: isSelected,
            excludeSemantics: true,
            child: monthWidget,
          ),
        );
      }

      monthsWidgetList.add(monthWidget);
      month++;
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(
        columnCount: 3,
        rowExtent: 60,
        rowStride: 80,
      ),
      childrenDelegate: SliverChildListDelegate(
        monthsWidgetList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
