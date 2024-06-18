import 'package:flutter/material.dart';

import '../shared/picker_type.dart';
import '../shared/types.dart';
import '../shared/utils.dart';
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
  /// It will display a grid of days for the [initialDate]'s month. If [initialDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The day indicated by [selectedDate] will be selected if provided.
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
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
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
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
    this.disabledDayPredicate,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
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
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disabledCellsDecoration;

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
  /// defaults to the color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Centring the leading date. e.g:
  ///
  /// <       December 2023      >
  ///
  final bool centerLeadingDate;

  /// Semantic label for button to go to the previous page.
  ///
  /// defaults to `Previous Day/Month/Year` according to picker type.
  final String? previousPageSemanticLabel;

  /// Semantic label for button to go to the next page.
  ///
  /// defaults to `Next Day/Month/Year` according to picker type.
  final String? nextPageSemanticLabel;

  /// A predicate function used to determine if a given day should be disabled.
  final DatePredicate? disabledDayPredicate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  PickerType? _pickerType;
  DateTime? _displayedDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    final clampedInitailDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    _pickerType = widget.initialPickerType;

    _selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatePicker oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) {
      final clampedInitailDate =
          DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    }
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      _pickerType = widget.initialPickerType;
    }
    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
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
            centerLeadingDate: widget.centerLeadingDate,
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
            enabledCellsTextStyle: widget.enabledCellsTextStyle,
            enabledCellsDecoration: widget.enabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
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
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            disabledDayPredicate: widget.disabledDayPredicate,
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.months;
              });
            },
            onDateSelected: (selectedDate) {
              setState(() {
                _displayedDate = selectedDate;
                _selectedDate = selectedDate;
              });
              widget.onDateSelected?.call(selectedDate);
            },
          ),
        );
      case PickerType.months:
        return Padding(
          padding: widget.padding,
          child: MonthPicker(
            centerLeadingDate: widget.centerLeadingDate,
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
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
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.years;
              });
            },
            onDateSelected: (selectedMonth) {
              // clamped the initial date to fall between min and max date.
              final clampedSelectedMonth = DateUtilsX.clampDateToRange(
                min: widget.minDate,
                max: widget.maxDate,
                date: selectedMonth,
              );
              setState(() {
                _displayedDate = clampedSelectedMonth;
                _pickerType = PickerType.days;
              });
            },
          ),
        );
      case PickerType.years:
        return Padding(
          padding: widget.padding,
          child: YearsPicker(
            centerLeadingDate: widget.centerLeadingDate,
            initialDate: _displayedDate,
            selectedDate: _selectedDate,
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDateDecoration: widget.currentDateDecoration,
            currentDateTextStyle: widget.currentDateTextStyle,
            disabledCellsDecoration: widget.disabledCellsDecoration,
            disabledCellsTextStyle: widget.disabledCellsTextStyle,
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
            previousPageSemanticLabel: widget.previousPageSemanticLabel,
            nextPageSemanticLabel: widget.nextPageSemanticLabel,
            onDateSelected: (selectedYear) {
              // clamped the initial date to fall between min and max date.
              final clampedSelectedYear = DateUtilsX.clampDateToRange(
                min: widget.minDate,
                max: widget.maxDate,
                date: selectedYear,
              );
              setState(() {
                _displayedDate = clampedSelectedYear;
                _pickerType = PickerType.months;
              });
            },
          ),
        );
    }
  }
}
