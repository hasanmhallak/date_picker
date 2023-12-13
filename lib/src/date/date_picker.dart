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
    this.currentDate,
    required this.onDateChanged,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.daysNameTextStyle,
    this.enabledCellColor,
    this.enabledCellTextStyle,
    this.enabledCellDecoration = const BoxDecoration(),
    this.disbaledCellColor,
    this.disbaledCellTextStyle,
    this.disbaledCellDecoration = const BoxDecoration(),
    this.currentDateColor,
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellColor,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
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
    assert(
      enabledCellColor == null || enabledCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "enabledDaysTextStyle: TextStyle(color: color)".',
    );
    assert(
      disbaledCellColor == null || disbaledCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "disbaledDaysTextStyle: TextStyle(color: color)".',
    );
    assert(
      currentDateColor == null || currentDateTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "todayTextStyle: TextStyle(color: color)".',
    );
    assert(
      selectedCellColor == null || selectedCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "selectedDayTextStyle: TextStyle(color: color)".',
    );
  }

  /// The date which will be displayed on first opening.
  final DateTime initialDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to today's date.
  final DateTime? currentDate;

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

  /// The text style of the days name in the header.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? daysNameTextStyle;

  /// The color of enabled cells which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledCellColor;

  /// The text style of cells which are selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration enabledCellDecoration;

  /// The color of disabled cells which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledCellColor;

  /// The text style of cells which are not selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disbaledCellTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disbaledCellDecoration;

  /// The color of the current date.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? currentDateColor;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  final BoxDecoration? currentDateDecoration;

  /// The color of the selected cell.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedCellColor;

  /// The text style of selected cell.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected cell.
  ///
  /// defaults to circle with [ColorScheme.primary] color.
  final BoxDecoration? selectedCellDecoration;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellDecoration],
  /// if null will fall back to [ColorScheme.onPrimary] with 30% opacity.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  ///
  /// defaults to [Theme.highlightColor].
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    //
    //
    //
    //! header
    final leadingTextStyle = widget.leadingDateTextStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        );

    final sliderSize = widget.slidersSize ?? 20;
    final slidersColor =
        widget.slidersColor ?? Theme.of(context).colorScheme.primary;

    //
    //! days of the week
    //
    //
    final TextStyle daysNameTextStyle = widget.daysNameTextStyle ??
        textTheme.titleSmall!.copyWith(
          color: colorScheme.onSurface.withOpacity(0.30),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );

    //
    //! enabled
    //
    //
    final Color enabledCellColor =
        widget.enabledCellColor ?? colorScheme.onSurface;

    final TextStyle enabledCellTextStyle = widget.enabledCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: enabledCellColor,
        );

    final BoxDecoration enabledCellDecoration = widget.enabledCellDecoration;

    //
    //! disabled
    //
    //
    final Color disbaledCellColor =
        widget.disbaledCellColor ?? colorScheme.onSurface.withOpacity(0.30);

    final TextStyle disbaledCellTextStyle = widget.disbaledCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: disbaledCellColor,
        );

    final BoxDecoration disbaledCellDecoration = widget.disbaledCellDecoration;

    //
    //! current
    //
    //
    final Color currentDateColor =
        widget.currentDateColor ?? colorScheme.primary;

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: currentDateColor,
        );

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: currentDateColor),
          shape: BoxShape.circle,
        );

    //
    //! selected.
    //
    //
    final Color selectedCellColor =
        widget.selectedCellColor ?? colorScheme.onPrimary;

    final TextStyle selectedCellTextStyle = widget.selectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: selectedCellColor,
        );

    final BoxDecoration selectedCellDecoration =
        widget.selectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );
    //
    //! splash
    final splashColor = widget.splashColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final highlightColor =
        widget.highlightColor ?? Theme.of(context).highlightColor;
    //
    //

    switch (_pickerType) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: DaysPicker(
            initialDate: _displayedDate!,
            currentDate:
                widget.currentDate ?? DateUtils.dateOnly(DateTime.now()),
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            daysNameTextStyle: daysNameTextStyle,
            enabledDaysTextStyle: enabledCellTextStyle,
            enabledDaysDecoration: enabledCellDecoration,
            disbaledDaysTextStyle: disbaledCellTextStyle,
            disbaledDaysDecoration: disbaledCellDecoration,
            todayDecoration: currentDateDecoration,
            todayTextStyle: currentDateTextStyle,
            selectedDayDecoration: selectedCellDecoration,
            selectedDayTextStyle: selectedCellTextStyle,
            slidersColor: slidersColor,
            slidersSize: sliderSize,
            leadingDateTextStyle: leadingTextStyle,
            splashColor: splashColor,
            highlightColor: highlightColor,
            splashRadius: widget.splashRadius,
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
            currentDate:
                widget.currentDate ?? DateUtils.dateOnly(DateTime.now()),
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentMonthDecoration: currentDateDecoration,
            currentMonthTextStyle: currentDateTextStyle,
            disbaledMonthDecoration: disbaledCellDecoration,
            disbaledMonthTextStyle: disbaledCellTextStyle,
            enabledMonthDecoration: enabledCellDecoration,
            enabledMonthTextStyle: enabledCellTextStyle,
            selectedMonthDecoration: selectedCellDecoration,
            selectedMonthTextStyle: selectedCellTextStyle,
            slidersColor: slidersColor,
            slidersSize: sliderSize,
            leadingDateTextStyle: leadingTextStyle,
            splashColor: splashColor,
            highlightColor: highlightColor,
            splashRadius: widget.splashRadius,
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
            currentDate:
                widget.currentDate ?? DateUtils.dateOnly(DateTime.now()),
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentYearDecoration: currentDateDecoration,
            currentYearTextStyle: currentDateTextStyle,
            disbaledYearDecoration: disbaledCellDecoration,
            disbaledYearTextStyle: disbaledCellTextStyle,
            enabledYearDecoration: enabledCellDecoration,
            enabledYearTextStyle: enabledCellTextStyle,
            selectedYearDecoration: selectedCellDecoration,
            selectedYearTextStyle: selectedCellTextStyle,
            slidersColor: slidersColor,
            slidersSize: sliderSize,
            leadingDateTextStyle: leadingTextStyle,
            splashColor: splashColor,
            highlightColor: highlightColor,
            splashRadius: widget.splashRadius,
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
