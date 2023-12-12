import 'package:flutter/material.dart';

import '../shared/month_picker.dart';
import '../shared/picker_type.dart';
import '../shared/year_picker.dart';
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
  /// Creates a calendar date range picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month.
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
  RangeDatePicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    required this.onRangeSelected,
    this.currentDate,
    this.initialDate,
    this.selectedRange,
    this.padding = const EdgeInsets.all(16),
    this.initialPickerType = PickerType.days,
    this.daysOfTheWeekTextStyle,
    this.enabledCellColor,
    this.enabledCellTextStyle,
    this.enabledCellDecoration = const BoxDecoration(),
    this.disbaledCellColor,
    this.disbaledCellTextStyle,
    this.disbaledCellDecoration = const BoxDecoration(),
    this.currentDateColor,
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellsColor,
    this.selectedCellsTextStyle,
    this.selectedCellsDecoration,
    this.singelSelectedCellColor,
    this.singelSelectedCellTextStyle,
    this.singelSelectedCellDecoration,
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
      () {
        if (selectedRange == null) return true;
        return (selectedRange!.start.isAfter(minDate) ||
                selectedRange!.start.isAtSameMomentAs(minDate)) &&
            (selectedRange!.start.isBefore(maxDate) ||
                selectedRange!.start.isAtSameMomentAs(maxDate));
      }(),
      "selected start date should be in the range of min date & max date",
    );

    assert(
      () {
        if (selectedRange == null) return true;
        return (selectedRange!.end.isAfter(minDate) ||
                selectedRange!.end.isAtSameMomentAs(minDate)) &&
            (selectedRange!.end.isBefore(maxDate) ||
                selectedRange!.end.isAtSameMomentAs(maxDate));
      }(),
      "selected end date should be in the range of min date & max date",
    );

    assert(
      enabledCellColor == null || enabledCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "enabledCellTextStyle: TextStyle(color: color)".',
    );
    assert(
      disbaledCellColor == null || disbaledCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "disbaledCellTextStyle: TextStyle(color: color)".',
    );
    assert(
      currentDateColor == null || currentDateTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "currentDateTextStyle: TextStyle(color: color)".',
    );
    assert(
      selectedCellsColor == null || selectedCellsTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "selectedCellTextStyle: TextStyle(color: color)".',
    );
    assert(
      singelSelectedCellColor == null || singelSelectedCellTextStyle == null,
      'Cannot provide both a color and a textStyle\n'
      'To provide both, use "singelSelectedCellTextStyle: TextStyle(color: color)".',
    );
  }

  /// The initially selected date range when the picker is first opened.
  /// If the specified range contains the [initialDate], that range will be selected.
  final DateTimeRange? selectedRange;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to today's date.
  final DateTime? currentDate;

  /// The date to which the picker will be initially opened.
  /// If not specified, the picker will default to today's date.
  final DateTime? initialDate;

  /// Called when the user picks a range.
  final ValueChanged<DateTimeRange> onRangeSelected;

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

  /// The text style of the week days name in the header.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? daysOfTheWeekTextStyle;

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
  ///
  /// ### Note:
  /// If [currentDate] is within the selected range this will
  /// be override by [selectedCellsColor]
  final Color? currentDateColor;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  ///
  /// ### Note:
  /// If [currentDate] is within the selected range this will
  /// be override by [selectedCellsTextStyle]
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  ///
  /// ### Note:
  /// If [currentDate] is within the selected range this will
  /// be override by [selectedCellsDecoration]
  final BoxDecoration? currentDateDecoration;

  /// The color of the selected cells within the range.
  ///
  /// defaults to [ColorScheme.onPrimaryContainer].
  final Color? selectedCellsColor;

  /// The text style of selected cells within the range.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimaryContainer] color.
  final TextStyle? selectedCellsTextStyle;

  /// The cell decoration of selected cells within the range.
  ///
  /// defaults to circle with [ColorScheme.primaryContainer] color.
  final BoxDecoration? selectedCellsDecoration;

  /// The color for a cell's text representing:
  ///
  /// 1. A single cell when initially selected.
  /// 2. The leading/trailing cell of a selected range.
  ///
  /// If not provided, `singelSelectedCellColor` defaults to the color specified
  /// in `selectedCellsDecoration`, using [ColorScheme.onPrimary].
  final Color? singelSelectedCellColor;

  /// The text style for a cell representing:
  ///
  /// 1. A single cell when initially selected.
  /// 2. The leading/trailing cell of a selected range.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color
  final TextStyle? singelSelectedCellTextStyle;

  /// The decoration for a cell representing:
  ///
  /// 1. A single cell when initially selected.
  /// 2. The leading/trailing cell of a selected range.
  ///
  /// If not provided, `singelSelectedCellDecoration` is a circle with the color specified
  /// in `selectedCellsDecoration`, using [ColorScheme.primary].
  final BoxDecoration? singelSelectedCellDecoration;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellsDecoration],
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
  State<RangeDatePicker> createState() => _RangeDatePickerState();
}

class _RangeDatePickerState extends State<RangeDatePicker> {
  PickerType? _pickerType;
  DateTime? _diplayedDate;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    _pickerType = widget.initialPickerType;
    if (widget.selectedRange != null) {
      _selectedStartDate = widget.selectedRange!.start;
      _selectedEndDate = widget.selectedRange!.end;
    }

    if (widget.initialDate != null) {
      _diplayedDate = DateUtils.dateOnly(widget.initialDate!);
    } else {
      _diplayedDate = DateUtils.dateOnly(widget.currentDate ?? DateTime.now());
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RangeDatePicker oldWidget) {
    if (oldWidget.initialPickerType != widget.initialPickerType) {
      _pickerType = widget.initialPickerType;
    }

    if (widget.selectedRange != oldWidget.selectedRange) {
      _selectedStartDate = widget.selectedRange?.start;
      _selectedEndDate = widget.selectedRange?.end;
    }

    if (widget.initialDate != oldWidget.initialDate) {
      _diplayedDate = DateUtils.dateOnly(widget.initialDate!);
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
          color: colorScheme.primary,
        );

    final sliderSize = widget.slidersSize ?? 20;
    final slidersColor = widget.slidersColor ?? colorScheme.primary;

    //
    //! days of the week
    //
    //
    final TextStyle daysNameTextStyle = widget.daysOfTheWeekTextStyle ??
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
    final Color selectedCellsColor =
        widget.selectedCellsColor ?? colorScheme.onPrimaryContainer;

    final TextStyle selectedCellsTextStyle = widget.selectedCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: selectedCellsColor,
        );

    final BoxDecoration selectedCellsDecoration =
        widget.selectedCellsDecoration ??
            BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.rectangle,
            );

    //
    //? singel
    final Color singelSelectedCellColor =
        widget.singelSelectedCellColor ?? colorScheme.onPrimary;

    final TextStyle singelSelectedCellTextStyle =
        widget.singelSelectedCellTextStyle ??
            textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: singelSelectedCellColor,
            );

    final BoxDecoration singelSelectedCellDecoration =
        widget.singelSelectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );

    //
    //! splash
    final splashColor = widget.splashColor ??
        selectedCellsDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final highlightColor =
        widget.highlightColor ?? Theme.of(context).highlightColor;
    //
    //

    switch (_pickerType!) {
      case PickerType.days:
        return Padding(
          padding: widget.padding,
          child: RangeDaysPicker(
            currentDate:
                widget.currentDate ?? DateUtils.dateOnly(DateTime.now()),
            initailDate: _diplayedDate!,
            selectedEndDate: _selectedEndDate,
            selectedStartDate: _selectedStartDate,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            daysOfTheWeekTextStyle: daysNameTextStyle,
            enabledCellsTextStyle: enabledCellTextStyle,
            enabledCellsDecoration: enabledCellDecoration,
            disbaledCellsTextStyle: disbaledCellTextStyle,
            disbaledCellsDecoration: disbaledCellDecoration,
            currentDecoration: currentDateDecoration,
            currentTextStyle: currentDateTextStyle,
            selectedCellsDecoration: selectedCellsDecoration,
            selectedCellsTextStyle: selectedCellsTextStyle,
            singelSelectedCellTextStyle: singelSelectedCellTextStyle,
            singelSelectedCellDecoration: singelSelectedCellDecoration,
            slidersColor: slidersColor,
            slidersSize: sliderSize,
            leadingDateTextStyle: leadingTextStyle,
            splashColor: splashColor,
            highlightColor: highlightColor,
            splashRadius: widget.splashRadius,
            materialLocalizations: MaterialLocalizations.of(context),
            onLeadingDateTap: () {
              setState(() {
                _pickerType = PickerType.months;
              });
            },
            onEndDateChanged: (date) {
              setState(() {
                _selectedEndDate = date;
              });

              // this should never be null
              if (_selectedStartDate != null) {
                widget.onRangeSelected(
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
            },
          ),
        );
      case PickerType.months:
        return Padding(
          padding: widget.padding,
          child: MonthPicker(
            initialDate: _diplayedDate!,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentMonthDecoration: currentDateDecoration,
            currentMonthTextStyle: currentDateTextStyle,
            disbaledMonthDecoration: disbaledCellDecoration,
            disbaledMonthTextStyle: disbaledCellTextStyle,
            enabledMonthDecoration: enabledCellDecoration,
            enabledMonthTextStyle: enabledCellTextStyle,
            selectedMonthDecoration: singelSelectedCellDecoration,
            selectedMonthTextStyle: singelSelectedCellTextStyle,
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
                _diplayedDate = selectedMonth;
                _pickerType = PickerType.days;
              });
            },
          ),
        );
      case PickerType.years:
        return Padding(
          padding: widget.padding,
          child: YearsPicker(
            initialDate: _diplayedDate!,
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            currentYearDecoration: currentDateDecoration,
            currentYearTextStyle: currentDateTextStyle,
            disbaledYearDecoration: disbaledCellDecoration,
            disbaledYearTextStyle: disbaledCellTextStyle,
            enabledYearDecoration: enabledCellDecoration,
            enabledYearTextStyle: enabledCellTextStyle,
            selectedYearDecoration: singelSelectedCellDecoration,
            selectedYearTextStyle: singelSelectedCellTextStyle,
            slidersColor: slidersColor,
            slidersSize: sliderSize,
            leadingDateTextStyle: leadingTextStyle,
            splashColor: splashColor,
            highlightColor: highlightColor,
            splashRadius: widget.splashRadius,
            onChange: (selectedYear) {
              setState(() {
                _diplayedDate = selectedYear;
                _pickerType = PickerType.months;
              });
            },
          ),
        );
    }
  }
}
