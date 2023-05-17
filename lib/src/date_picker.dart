import 'package:flutter/material.dart';

import 'days_picker.dart';
import 'month_picker.dart';
import 'year_picker.dart';
import 'show_date_picker_dialog.dart';

/// Initial display of a calendar date picker.
///
/// Either a grid of available years or a monthly calendar.
///
/// See also:
///
///  * [showDatePickerDialog], which shows a dialog that contains a Material Design
///    date picker.
///  * [DatePicker], widget which implements the Material Design date picker.
///
enum PickerType {
  /// Choosing a day.
  days,

  /// Choosing a month.
  months,

  /// Choosing a year.
  years,
}

/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The date picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view where the
///
class DatePicker extends StatefulWidget {
  /// Creates a calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. The day
  /// indicated by [initialDate] will be selected.
  ///
  /// The user interface provides a way to change the year of the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// to start in the month selection interface with [initialPickerType] set
  /// to [PickerType.month].
  ///
  /// The [initialDate], [minDate], [maxDate], [onDateChanged], and
  /// [initialPickerType] must be non-null.
  ///
  /// [maxDate] must be after or equal to [minDate].
  ///
  /// [initialDate] must be between [maxDate] and [minDate] or equal to
  /// one of them.
  ///
  DatePicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
    required this.onDateChanged,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.daysNameColor,
    this.enabledCellsColor,
    this.disbaledCellsColor,
    this.todayColor,
    this.selectedCellColor,
    this.selectedCellFillColor,
  }) {
    assert(
      !maxDate.isBefore(minDate),
      'maxDate $maxDate must be on or after minDate $minDate.',
    );
    assert(
      !initialDate.isBefore(minDate),
      'initialDate $initialDate must be on or after minDate $minDate.',
    );
    assert(
      !initialDate.isAfter(maxDate),
      'initialDate $initialDate must be on or before maxDate $maxDate.',
    );
  }

  /// The date which will be displayed on first opening.
  final DateTime initialDate;

  /// Called when the user picks a month.
  final ValueChanged<DateTime> onDateChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The initial display of the calendar picker.
  final PickerType initialPickerType;

  /// The amount of padding to be added around the [DatePicker].
  final EdgeInsets padding;

  /// The color of the days name.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? daysNameColor;

  /// The color of enabled cells which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledCellsColor;

  /// The color of disabled cells which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledCellsColor;

  /// The color of the current day.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? todayColor;

  /// The color of the selected cell.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedCellColor;

  /// The fill color of the selected cell.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? selectedCellFillColor;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  PickerType _pickerType = PickerType.days;
  DateTime? _displayedDate;

  @override
  void initState() {
    _displayedDate = widget.initialDate;
    _pickerType = widget.initialPickerType;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) {
      _displayedDate = widget.initialDate;
    }
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      _pickerType = widget.initialPickerType;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    switch (_pickerType) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: DaysPicker(
            initialDate: _displayedDate!,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            daysNameColor: widget.daysNameColor,
            disbaledDaysColor: widget.disbaledCellsColor,
            enabledDaysColor: widget.enabledCellsColor,
            selectedDayColor: widget.selectedCellColor,
            selectedDayFillColor: widget.selectedCellFillColor,
            todayColor: widget.todayColor,
            onChange: (selectedDate) {
              setState(() {
                _displayedDate = selectedDate;
              });
              widget.onDateChanged(selectedDate);
            },
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.months;
              });
            },
          ),
        );
      case PickerType.months:
        return Padding(
          padding: widget.padding,
          child: MonthPicker(
            initialDate: _displayedDate!,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentMonthColor: widget.todayColor,
            disbaledMonthsColor: widget.disbaledCellsColor,
            enabledMonthsColor: widget.enabledCellsColor,
            selectedMonthColor: widget.selectedCellColor,
            selectedMonthFillColor: widget.selectedCellFillColor,
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.years;
              });
            },
            onChange: (selectedMonth) {
              setState(() {
                _displayedDate = selectedMonth;
                _pickerType = PickerType.days;
              });
            },
          ),
        );
      case PickerType.years:
        return Padding(
          padding: widget.padding,
          child: YearsPicker(
            initialDate: _displayedDate!,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentYearColor: widget.todayColor,
            disbaledYearColor: widget.disbaledCellsColor,
            enabledYearColor: widget.enabledCellsColor,
            selectedYearColor: widget.selectedCellColor,
            selectedYearFillColor: widget.selectedCellFillColor,
            onChange: (selectedYear) {
              setState(() {
                _displayedDate = selectedYear;
                _pickerType = PickerType.months;
              });
            },
          ),
        );
    }
  }
}
