import 'package:flutter/material.dart';

import '../shared/picker_type.dart';
import 'days_picker.dart';
import '../shared/month_picker.dart';
import '../shared/year_picker.dart';
import 'show_date_picker_dialog.dart';

/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The date picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///
class DatePicker extends StatefulWidget {
  /// Creates a calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. if that
  /// is null, `DateTime.now()` will be used. The day
  /// indicated by [selectedDate] will be selected if provided.
  ///
  /// The optional [onDateSelected] callback will be called if provided when a date
  /// is selected.
  ///
  /// The user interface provides a way to change the year and the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// with [initialPickerType].
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [initialDate] and [selectedDate] must either fall between
  /// these dates, or be equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// For each of these [DateTime] parameters, only
  /// their dates are considered. Their time fields are ignored.
  DatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onDateSelected,
    this.initialDate,
    this.selectedDate,
    this.currentDate,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.daysOfTheWeekTextStyle,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disbaledCellsTextStyle,
    this.disbaledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  /// The date which will be displayed on first opening.
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? initialDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The initially selected date when the picker is first opened.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime maxDate;

  /// The initial display of the calendar picker.
  final PickerType initialPickerType;

  /// The amount of padding to be added around the [DatePicker].
  final EdgeInsets padding;

  /// The text style of the days of the week in the header.
  ///
  /// defaults to [TextTheme.titleSmall] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? daysOfTheWeekTextStyle;

  /// The text style of cells which are selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disbaledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disbaledCellsDecoration;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  final BoxDecoration? currentDateDecoration;

  /// The text style of selected cell.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected cell.
  ///
  /// defaults to circle with [ColorScheme.primary] color.
  final BoxDecoration? selectedCellDecoration;

  /// The text style of leading date showing in the header.
  ///
  /// defaults to `18px` with a [FontWeight.bold]
  /// and [ColorScheme.primary] color.
  final TextStyle? leadingDateTextStyle;

  /// The color of the page sliders.
  ///
  /// defaults to [ColorScheme.primary] color.
  final Color? slidersColor;

  /// The size of the page sliders.
  ///
  /// defaults to `20px`.
  final double? slidersSize;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  ///
  /// defaults to [Theme.highlightColor].
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  PickerType? _pickerType;
  DateTime? _displayedDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    _displayedDate = DateUtils.dateOnly(widget.initialDate ?? DateTime.now());
    _pickerType = widget.initialPickerType;

    _selectedDate = widget.selectedDate != null
        ? DateUtils.dateOnly(widget.selectedDate!)
        : null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) {
      _displayedDate = DateUtils.dateOnly(widget.initialDate ?? DateTime.now());
    }
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      _pickerType = widget.initialPickerType;
    }
    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null
          ? DateUtils.dateOnly(widget.selectedDate!)
          : null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    switch (_pickerType!) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: DaysPicker(
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            disbaledCellsTextStyle: widget.disbaledCellsTextStyle,
            disbaledCellsDecoration: widget.disbaledCellsDecoration,
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            selectedCellDecoration: widget.selectedCellDecoration,
            selectedCellTextStyle: widget.selectedCellTextStyle,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            onDateSelected: (selectedDate) {
              setState(() {
                _displayedDate = selectedDate;
                _selectedDate = selectedDate;
              });
              widget.onDateSelected?.call(selectedDate);
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
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disbaledCellsDecoration: widget.disbaledCellsDecoration,
            disbaledCellsTextStyle: widget.disbaledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            selectedCellDecoration: widget.selectedCellDecoration,
            selectedCellTextStyle: widget.selectedCellTextStyle,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.years;
              });
            },
            onDateSelected: (selectedMonth) {
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
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate:
                DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disbaledCellsDecoration: widget.disbaledCellsDecoration,
            disbaledCellsTextStyle: widget.disbaledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            selectedCellDecoration: widget.selectedCellDecoration,
            selectedCellTextStyle: widget.selectedCellTextStyle,
            slidersColor: widget.slidersColor,
            slidersSize: widget.slidersSize,
            leadingDateTextStyle: widget.leadingDateTextStyle,
            splashColor: widget.splashColor,
            highlightColor: widget.highlightColor,
            splashRadius: widget.splashRadius,
            onDateSelected: (selectedYear) {
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
