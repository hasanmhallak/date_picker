import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'picker_grid_delegate.dart';
import 'utils.dart';

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
    this.selectedDate,
    required this.displayedDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disabledCellsTextStyle,
    required this.disabledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedCellTextStyle,
    required this.selectedCellDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(() {
      if (selectedDate == null) return true;
      final max = DateUtilsX.monthOnly(maxDate);
      final min = DateUtilsX.monthOnly(minDate);
      final selected = DateUtilsX.monthOnly(selectedDate!);

      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  /// The currently selected month.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime? selectedDate;

  /// The current month at the time the picker is displayed.
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime currentDate;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime maxDate;

  /// The year which its months are displayed by this picker.
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime displayedDate;

  /// The text style of months which are selectable.
  final TextStyle enabledCellsTextStyle;

  /// The cell decoration of months which are selectable.
  final BoxDecoration enabledCellsDecoration;

  /// The text style of months which are not selectable.
  final TextStyle disabledCellsTextStyle;

  /// The cell decoration of months which are not selectable.
  final BoxDecoration disabledCellsDecoration;

  /// The text style of the current month
  final TextStyle currentDateTextStyle;

  /// The cell decoration of the current month.
  final BoxDecoration currentDateDecoration;

  /// The text style of selected month.
  final TextStyle selectedCellTextStyle;

  /// The cell decoration of selected month.
  final BoxDecoration selectedCellDecoration;

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

    final int year = displayedDate.year;
    // we get rid of the day because if there is any day allowed in
    // in the month we should not gray it out.
    final DateTime startMonth = DateUtilsX.monthOnly(minDate);
    final DateTime endMonth = DateUtilsX.monthOnly(maxDate);
    DateTime? selectedMonth;

    if (selectedDate != null) {
      selectedMonth = DateUtilsX.monthOnly(selectedDate!);
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
          monthToBuild == DateUtilsX.monthOnly(currentDate);

      final bool isSelected = monthToBuild == selectedMonth;
      //
      //
      BoxDecoration decoration = enabledCellsDecoration;
      TextStyle style = enabledCellsTextStyle;

      if (isCurrentMonth) {
        //
        //
        style = currentDateTextStyle;
        decoration = currentDateDecoration;
      }
      if (isSelected) {
        //
        //
        style = selectedCellTextStyle;
        decoration = selectedCellDecoration;
      }

      if (isDisabled) {
        style = disabledCellsTextStyle;
        decoration = disabledCellsDecoration;
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
          radius: splashRadius,
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
      gridDelegate: const PickerGridDelegate(columnCount: 3, rowCount: 4),
      childrenDelegate: SliverChildListDelegate(
        monthsWidgetList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
