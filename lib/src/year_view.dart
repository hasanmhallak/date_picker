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
    this.enabledYearColor,
    this.disbaledYearColor,
    this.currentYearColor,
    this.selectedYearColor,
    this.selectedYearFillColor,
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

  /// The color of enabled month which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledYearColor;

  /// The color of disabled months which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledYearColor;

  /// The color of the current month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? currentYearColor;

  /// The color of the selected month.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedYearColor;

  /// The fill color of the selected month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? selectedYearFillColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    final Color enabledYearColor =
        this.enabledYearColor ?? colorScheme.onSurface;
    final Color currentYearBorderColor =
        this.currentYearColor ?? colorScheme.primary;
    final Color currentYearColor = this.currentYearColor ?? colorScheme.primary;

    final Color disabledYearColor =
        disbaledYearColor ?? colorScheme.onSurface.withOpacity(0.30);

    //
    final Color selectedYearColor =
        this.selectedYearColor ?? colorScheme.onPrimary;

    final Color selectedYearBackground =
        selectedYearFillColor ?? colorScheme.primary;
    //
    final TextStyle yearStyle = textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 20,
    );
    final int currentYear = currentDate.year;
    final int startYear = displayedYearRange.start.year;
    final int endYear = displayedYearRange.end.year;
    final int numberOfYears = endYear - startYear + 1;

    final yearsName = List.generate(
      numberOfYears,
      (index) => startYear + index,
    );

    final monthsWidgetList = <Widget>[];

    int i = 0;
    while (i < numberOfYears) {
      final bool isDisabled =
          yearsName[i] > maxDate.year || yearsName[i] < minDate.year;

      final bool isCurrentYear = yearsName[i] == currentYear;

      final bool isSelected = yearsName[i] == selectedYear?.year;
      //
      //
      BoxDecoration? decoration;
      Color monthColor = enabledYearColor;

      if (isCurrentYear) {
        // The selected month gets a circle background highlight, and a
        // contrasting text color.
        monthColor = currentYearColor;
        decoration = BoxDecoration(
          border: Border.all(color: currentYearBorderColor),
          shape: BoxShape.circle,
        );
      }
      if (isSelected) {
        monthColor = selectedYearColor;
        decoration = BoxDecoration(
          color: selectedYearBackground,
          shape: BoxShape.circle,
        );
      }

      if (isDisabled) {
        monthColor = disabledYearColor;
      }

      Widget monthWidget = Container(
        decoration: decoration,
        child: Center(
          child: Text(
            yearsName[i].toString(),
            style: yearStyle.copyWith(color: monthColor),
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
          radius: 60 / 2 + 4,
          splashColor: currentYearBorderColor.withOpacity(0.38),
          child: Semantics(
            label: yearsName[i].toString(),
            selected: isCurrentYear,
            excludeSemantics: true,
            child: monthWidget,
          ),
        );
      }

      monthsWidgetList.add(monthWidget);
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
        monthsWidgetList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
