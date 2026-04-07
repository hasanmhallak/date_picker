import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import 'picker_grid_delegate.dart';
import 'utils.dart';

/// Displays the years of a given range and allows choosing a year.
///
/// Years are arranged in a rectangular grid with tree columns.
class YearView extends StatelessWidget {
  /// Displays the years of a given range and allows choosing a year.
  ///
  /// Years are arranged in a rectangular grid with tree columns.
  YearView({
    super.key,
    required this.maxDate,
    required this.minDate,
    required this.currentDate,
    this.selectedDate,
    required this.onChanged,
    required this.displayedYearRange,
    this.cellBuilder,
    this.theme,
    this.isEnabled = true,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(() {
      return displayedYearRange.end.year - displayedYearRange.start.year == 11;
    }(), "the display year range must always be 12 years.");

    assert(() {
      if (selectedDate == null) return true;
      final max = DateUtilsX.yearOnly(maxDate);
      final min = DateUtilsX.yearOnly(minDate);
      final selected = DateUtilsX.yearOnly(selectedDate!);
      return (selected.isAfter(min) || selected.isAtSameMomentAs(min)) &&
          (selected.isBefore(max) || selected.isAtSameMomentAs(max));
    }(), "selected date should be in the range of min date & max date");
  }

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime? selectedDate;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime currentDate;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime maxDate;

  /// The years range whose years are displayed by this picker.
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTimeRange displayedYearRange;

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final YearsPickerTheme? theme;

  /// When `false`, years are not selectable and semantics report as disabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final int currentYear = currentDate.year;
    final int startYear = displayedYearRange.start.year;
    final int endYear = displayedYearRange.end.year;
    final int numberOfYears = endYear - startYear + 1;

    final defaultTheme = DatePickerPlusTheme.defaults(context).yearsPickerTheme;
    final contextTheme =
        Theme.of(context).extension<DatePickerPlusTheme>()?.yearsPickerTheme;
    final currentTheme = defaultTheme?.merge(contextTheme).merge(theme);

    final inkResponseTheme = currentTheme?.inkResponseTheme;
    final cellsPadding = currentTheme?.cellsPadding ??
        const EdgeInsets.symmetric(horizontal: 8, vertical: 16);

    final yearsName = List.generate(
      numberOfYears,
      (index) => startYear + index,
    );

    final yearWidgetsList = <Widget>[];

    int i = 0;
    while (i < numberOfYears) {
      final bool isYearDisabled =
          yearsName[i] > maxDate.year || yearsName[i] < minDate.year;

      final bool isCurrentYear = yearsName[i] == currentYear;

      final bool isSelected = yearsName[i] == selectedDate?.year;

      CellState state = CellState.enabled;
      if (isYearDisabled && isCurrentYear) {
        state = CellState.currentAndDisabled;
      } else if (isYearDisabled) {
        state = CellState.disabled;
      } else if (isSelected) {
        state = CellState.selected;
      } else if (isCurrentYear) {
        state = CellState.current;
      }

      final style = currentTheme?.resolveTextStyle(state);
      final decoration = currentTheme?.resolveDecoration(state);

      Widget monthWidget = Padding(
        padding: cellsPadding,
        child: Container(
          decoration: decoration,
          child: Center(
            child: Text(
              yearsName[i].toString(),
              style: style,
            ),
          ),
        ),
      );

      if (cellBuilder != null) {
        monthWidget = ExcludeSemantics(
          child: cellBuilder!(
            context,
            YearCell(year: yearsName[i], state: state, child: monthWidget),
          ),
        );
      }

      final String yearSemanticLabel = yearsName[i].toString();

      if (!isEnabled) {
        monthWidget = Semantics(
          label: yearSemanticLabel,
          selected: isSelected,
          enabled: false,
          excludeSemantics: true,
          child: monthWidget,
        );
      } else if (isYearDisabled) {
        monthWidget = ExcludeSemantics(
          child: monthWidget,
        );
      } else {
        final date = DateTime(yearsName[i]);
        monthWidget = InkResponse(
          onTap: () => onChanged(date),
          radius: inkResponseTheme?.radius,
          splashColor: inkResponseTheme?.splashColor ?? Colors.transparent,
          highlightColor:
              inkResponseTheme?.highlightColor ?? Colors.transparent,
          borderRadius: inkResponseTheme?.borderRadius,
          containedInkWell: inkResponseTheme?.containedInkWell ?? false,
          customBorder: inkResponseTheme?.customBorder,
          highlightShape: inkResponseTheme?.highlightShape ?? BoxShape.circle,
          splashFactory: inkResponseTheme?.splashFactory,
          focusColor: inkResponseTheme?.focusColor,
          hoverColor: inkResponseTheme?.hoverColor,
          child: Semantics(
            label: yearSemanticLabel,
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
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(columnCount: 3, rowCount: 4),
      childrenDelegate: SliverChildListDelegate(
        yearWidgetsList,
        addRepaintBoundaries: false,
      ),
    );
  }
}
