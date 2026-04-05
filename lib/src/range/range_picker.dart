import 'package:flutter/material.dart';

import '../shared/month_picker.dart';
import '../shared/picker_type.dart';
import '../shared/types.dart';
import '../shared/utils.dart';
import '../shared/year_picker.dart';
import '../theme/date_picker_plus_theme.dart';
import 'range_days_picker.dart';

/// Displays a grid of days for a given month and allows the user to select a
/// range of dates.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The range picker widget is rarely used directly. Instead, consider using
/// [showRangeDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showRangeDatePickerDialog], which creates a Dialog that contains a
///    [RangeDatePicker].
///
class RangeDatePicker extends StatefulWidget {
  /// Creates a calendar range picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month. If [initialDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The day indicated by [selectedRange] will be selected if provided.
  ///
  /// The optional [onRangeSelected] callback will be called if provided
  /// when a range is selected.
  ///
  /// The user interface provides a way to change the year and the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// with [initialPickerType].
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [initialDate] and [selectedRange] must either fall between
  /// these dates, or be equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// For each of these [DateTime] parameters, only
  /// their dates are considered. Their time fields are ignored.
  RangeDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.onRangeSelected,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.currentDate,
    this.initialDate,
    this.selectedRange,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.cellBuilder,
    this.theme,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
  }

  /// The initially selected date range when the picker is first opened.
  /// If the specified range contains the [initialDate], that range will be selected.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTimeRange? selectedRange;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to today's date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? initialDate;

  /// Called when the user picks a range.
  final ValueChanged<DateTimeRange>? onRangeSelected;

  /// Called when the user selects between months/years/days
  final VoidCallback? onLeadingDateTap;

  /// Called when the user picks a new start date to the range
  final ValueChanged<DateTime>? onStartDateChanged;

  /// Called when the user picks an end date to the range
  final ValueChanged<DateTime>? onEndDateChanged;

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

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// The theme to apply to the [RangeDatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DatePickerPlusTheme? theme;

  @override
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
  PickerType? _pickerType;
  DateTime? _displayedDate;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    _pickerType = widget.initialPickerType;
    final clampedInitailDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);

    if (widget.selectedRange != null) {
      _selectedStartDate = DateUtils.dateOnly(widget.selectedRange!.start);
      _selectedEndDate = DateUtils.dateOnly(widget.selectedRange!.end);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RangeDatePicker oldWidget) {
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      _pickerType = widget.initialPickerType;
    }

    if (widget.selectedRange != oldWidget.selectedRange) {
      if (widget.selectedRange == null) {
        _selectedStartDate = null;
        _selectedEndDate = null;
      } else {
        _selectedStartDate = DateUtils.dateOnly(widget.selectedRange!.start);
        _selectedEndDate = DateUtils.dateOnly(widget.selectedRange!.end);
      }
    }

    if (widget.initialDate != oldWidget.initialDate) {
      final clampedInitailDate =
          DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedDate = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final defaultTheme = DatePickerPlusTheme.defaults(context);
    final contextTheme = Theme.of(context).extension<DatePickerPlusTheme>();
    final DatePickerPlusTheme theme = defaultTheme.merge(contextTheme).merge(widget.theme);

    switch (_pickerType!) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: RangeDaysPicker(
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            initialDate: _displayedDate,
            selectedEndDate: _selectedEndDate,
            selectedStartDate: _selectedStartDate,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            theme: theme,
            cellBuilder: widget.cellBuilder,
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.months;
              });

              widget.onLeadingDateTap?.call();
            },
            onEndDateChanged: (date) {
              setState(() {
                _selectedEndDate = date;
              });

              widget.onEndDateChanged?.call(date);

              // this should never be null
              if (_selectedStartDate != null) {
                widget.onRangeSelected?.call(
                  DateTimeRange(
                    start: _selectedStartDate!,
                    end: _selectedEndDate!,
                  ),
                );
              }
            },
            onStartDateChanged: (date) {
              setState(() {
                _selectedStartDate = date;
                _selectedEndDate = null;
              });

              widget.onStartDateChanged?.call(date);
            },
          ),
        );
      case PickerType.months:
        return Padding(
          padding: widget.padding,
          child: MonthPicker(
            initialDate: _displayedDate,
            selectedDate: null,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            theme: theme,
            cellBuilder: widget.cellBuilder,
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
            selectedDate: null,
            initialDate: _displayedDate,
            maxDate: DateUtils.dateOnly(widget.maxDate),
            minDate: DateUtils.dateOnly(widget.minDate),
            currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
            theme: theme,
            cellBuilder: widget.cellBuilder,
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
