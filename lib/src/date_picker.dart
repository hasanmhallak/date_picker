import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'days_picker.dart';
import 'header.dart';
import 'month_picker.dart';
import 'year_picker.dart';

enum PickerType {
  days,
  months,
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
/// [showDatePicker], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePicker], which creates a Dialog that contains a
///    [CalendarDatePicker] and provides an optional compact view where the
///    user can enter a date as a line of text.
///  * [showTimePicker], which shows a dialog that contains a Material Design
///    time picker.
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

  final DateTime initialDate;
  final DateTime maxDate;
  final DateTime minDate;
  final PickerType initialPickerType;
  final ValueChanged<DateTime> onDateChanged;
  final EdgeInsets padding;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  PickerType _pickerType = PickerType.days;
  DateTime? _displayedDate;

  @override
  void initState() {
    _displayedDate = widget.initialDate;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) {
      _displayedDate = widget.initialDate;
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
            onChange: (selectedMonth) {
              setState(() {
                _displayedDate = selectedMonth;
                _pickerType = PickerType.months;
              });
            },
          ),
        );
    }
  }
}
