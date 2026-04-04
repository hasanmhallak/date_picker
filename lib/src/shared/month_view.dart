import 'package:date_picker_plus/date_picker_plus.dart';
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
    this.theme,
    this.isEnabled = true,
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

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final MonthsPickerTheme? theme;

  /// When `false`, months are not selectable and semantics report as disabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final defaultTheme = DatePickerPlusTheme.defaults(context).monthsPickerTheme;
    final contextTheme = Theme.of(context).extension<DatePickerPlusTheme>()?.monthsPickerTheme;
    final theme = defaultTheme?.merge(contextTheme).merge(this.theme);

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final inkResponseTheme = theme?.inkResponseTheme;
    final cellsPadding = theme?.cellsPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 16);

    final int year = displayedDate.year;
    // we get rid of the day because if there is any day allowed in
    // in the month we should not gray it out.
    final DateTime startMonth = DateUtilsX.monthOnly(minDate);
    final DateTime endMonth = DateUtilsX.monthOnly(maxDate);
    DateTime? selectedMonth;

    if (selectedDate != null) {
      selectedMonth = DateUtilsX.monthOnly(selectedDate!);
    }

    final monthsNames = DateFormat('', locale.toString()).dateSymbols.STANDALONESHORTMONTHS;
    final monthsWidgetList = <Widget>[];

    int month = 0;
    while (month < 12) {
      final DateTime monthToBuild = DateTime(year, month + 1);

      final bool isMonthDisabled = monthToBuild.isAfter(endMonth) || monthToBuild.isBefore(startMonth);

      final bool isCurrentMonth = monthToBuild == DateUtilsX.monthOnly(currentDate);

      final bool isSelected = monthToBuild == selectedMonth;

      CellState state = CellState.enabled;
      if (isMonthDisabled && isCurrentMonth) {
        state = CellState.currentAndDisabled;
      } else if (isMonthDisabled) {
        state = CellState.disabled;
      } else if (isSelected) {
        state = CellState.selected;
      } else if (isCurrentMonth) {
        state = CellState.current;
      }

      final style = theme?.resolveTextStyle(state);
      final decoration = theme?.resolveDecoration(state);

      Widget monthWidget = Padding(
        padding: cellsPadding,
        child: Container(
          decoration: decoration,
          child: Center(
            child: Text(
              monthsNames[month],
              style: style,
            ),
          ),
        ),
      );

      final String monthSemanticLabel = localizations.formatMonthYear(monthToBuild);

      if (!isEnabled) {
        monthWidget = Semantics(
          label: monthSemanticLabel,
          selected: isSelected,
          enabled: false,
          excludeSemantics: true,
          child: monthWidget,
        );
      } else if (isMonthDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        monthWidget = InkResponse(
          onTap: () => onChanged(monthToBuild),
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
            label: monthSemanticLabel,
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
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(columnCount: 3, rowCount: 4),
      childrenDelegate: SliverChildListDelegate(
        monthsWidgetList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
