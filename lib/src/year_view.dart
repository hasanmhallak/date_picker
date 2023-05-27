import 'package:flutter/material.dart';

import 'picker_grid_delegate.dart';

/// Displays the years of a given range and allows choosing a year.
///
/// Years are arranged in a rectangular grid with tree columns.
class YearView extends StatelessWidget {
  /// Displays the years of a given range and allows choosing a year.
  ///
  /// Years are arranged in a rectangular grid with tree columns.
  YearView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.displayedYearRange,
    this.selectedYear,
    required this.enabledYearTextStyle,
    required this.enabledYearDecoration,
    required this.disbaledYearTextStyle,
    required this.disbaledYearDecoration,
    required this.currentYearTextStyle,
    required this.currentYearDecoration,
    required this.selectedYearTextStyle,
    required this.selectedYearDecoration,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
  })  : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate"),
        assert(() {
          return (displayedYearRange.end.year -
                  displayedYearRange.start.year) ==
              11;
        }(), "the display year range must always be 12 years."),
        assert(() {
          if (selectedYear == null) return true;
          return selectedYear.isAfter(minDate) &&
              selectedYear.isBefore(maxDate);
        }(), "selected date should be in the range of min date & max date");

  /// The currently selected year.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedYear;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
  final DateTime currentDate;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The years range whose years are displayed by this picker.
  final DateTimeRange displayedYearRange;

  /// The text style of years which are selectable.
  final TextStyle enabledYearTextStyle;

  /// The cell decoration of years which are selectable.
  final BoxDecoration enabledYearDecoration;

  /// The text style of years which are not selectable.
  final TextStyle disbaledYearTextStyle;

  /// The cell decoration of years which are not selectable.
  final BoxDecoration disbaledYearDecoration;

  /// The text style of the current year
  final TextStyle currentYearTextStyle;

  /// The cell decoration of the current year.
  final BoxDecoration currentYearDecoration;

  /// The text style of selected year.
  final TextStyle selectedYearTextStyle;

  /// The cell decoration of selected year.
  final BoxDecoration selectedYearDecoration;

  /// The splash color of the ink response.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  @override
  Widget build(BuildContext context) {
    final int currentYear = currentDate.year;
    final int startYear = displayedYearRange.start.year;
    final int endYear = displayedYearRange.end.year;
    final int numberOfYears = endYear - startYear + 1;

    final yearsName = List.generate(
      numberOfYears,
      (index) => startYear + index,
    );

    final yearWidgetsList = <Widget>[];

    int i = 0;
    while (i < numberOfYears) {
      final bool isDisabled =
          yearsName[i] > maxDate.year || yearsName[i] < minDate.year;

      final bool isCurrentYear = yearsName[i] == currentYear;

      final bool isSelected = yearsName[i] == selectedYear?.year;
      //
      //
      BoxDecoration decoration = enabledYearDecoration;
      TextStyle style = enabledYearTextStyle;

      if (isCurrentYear) {
        //
        //
        style = currentYearTextStyle;
        decoration = currentYearDecoration;
      }
      if (isSelected) {
        //
        //
        style = selectedYearTextStyle;
        decoration = selectedYearDecoration;
      }

      if (isDisabled) {
        style = disbaledYearTextStyle;
        decoration = disbaledYearDecoration;
      }

      Widget monthWidget = Container(
        decoration: decoration,
        child: Center(
          child: Text(
            yearsName[i].toString(),
            style: style,
          ),
        ),
      );

      if (isDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        final date = DateTime(yearsName[i]);
        monthWidget = InkResponse(
          onTap: () => onChanged(date),
          radius: splashRadius ?? 60 / 2 + 4,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: Semantics(
            label: yearsName[i].toString(),
            selected: isSelected,
            excludeSemantics: true,
            child: monthWidget,
          ),
        );
      }

      yearWidgetsList.add(monthWidget);
      i++;
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
        yearWidgetsList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
