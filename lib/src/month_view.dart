import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'picker_grid_delegate.dart';

/// Displays the months of a given year and allows choosing a month.
///
/// Months are arranged in a rectangular grid with tree columns.
class MonthView extends StatelessWidget {
  MonthView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.displayedYear,
    required this.selectedMonth,
    this.enabledMonthsColor,
    this.disbaledMonthsColor,
    this.currentMonthColor,
    this.selectedMonthColor,
    this.selectedMonthFillColor,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// The currently selected month.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedMonth;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
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

  /// The year whose months are displayed by this picker.
  final DateTime displayedYear;

  /// The color of enabled month which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledMonthsColor;

  /// The color of disabled months which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledMonthsColor;

  /// The color of the current month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? currentMonthColor;

  /// The color of the selected month.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedMonthColor;

  /// The fill color of the selected month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? selectedMonthFillColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    final Color enabledMonthColor = enabledMonthsColor ?? colorScheme.onSurface;
    final Color currentMonthBorderColor = colorScheme.primary;
    final Color currentMonthColor = colorScheme.primary;

    final Color disabledMonthColor =
        disbaledMonthsColor ?? colorScheme.onSurface.withOpacity(0.30);

    //
    final Color selectedMonthColor =
        this.selectedMonthColor ?? colorScheme.onPrimary;

    final Color selectedMonthBackground =
        selectedMonthFillColor ?? colorScheme.primary;
    //
    final TextStyle monthStyle = textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.normal,
    );
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
      BoxDecoration? decoration;
      Color monthColor = enabledMonthColor;

      if (isCurrentMonth) {
        // The selected month gets a circle background highlight, and a
        // contrasting text color.
        monthColor = currentMonthColor;
        decoration = BoxDecoration(
          border: Border.all(color: currentMonthBorderColor),
          shape: BoxShape.circle,
        );
      }
      if (isSelected) {
        monthColor = selectedMonthColor;
        decoration = BoxDecoration(
          color: selectedMonthBackground,
          shape: BoxShape.circle,
        );
      }

      if (isDisabled) {
        monthColor = disabledMonthColor;
      }

      Widget monthWidget = Container(
        decoration: decoration,
        child: Center(
          child: Text(
            monthsNames[month],
            style: monthStyle.copyWith(color: monthColor),
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
          radius: 60 / 2.5 + 4,
          splashColor: currentMonthBorderColor.withOpacity(0.38),
          child: Semantics(
            label: localizations.formatMediumDate(monthToBuild),
            selected: isCurrentMonth,
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
      physics: const ClampingScrollPhysics(),
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
