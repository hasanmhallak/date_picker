// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'days_view.dart';
import 'header.dart';
import 'show_date_picker_dialog.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The days picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view where the
///
class _DaysPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// The [maxDate], [minDate], [initialDate] arguments
  /// must be non-null. The [minDate] must be after the [maxDate].
  _DaysPicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
    required this.materialLocalizations,
    required this.daysNameTextStyle,
    required this.enabledDaysTextStyle,
    required this.enabledDaysDecoration,
    required this.disbaledDaysTextStyle,
    required this.disbaledDaysDecoration,
    required this.todayTextStyle,
    required this.todayDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.onLeadingDateTap,
    required this.onChange,
    required this.leadingDateTextStyle,
    required this.slidersColor,
    required this.slidersSize,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// Called when the user picks a month.
  final ValueChanged<DateTime>? onChange;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The date which will be displayed on first opening.
  final DateTime initialDate;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of the days name.
  final TextStyle daysNameTextStyle;

  /// The text style of days which are selectable.
  final TextStyle enabledDaysTextStyle;

  /// The cell decoration of days which are selectable.
  final BoxDecoration enabledDaysDecoration;

  /// The text style of days which are not selectable.
  final TextStyle disbaledDaysTextStyle;

  /// The cell decoration of days which are not selectable.
  final BoxDecoration disbaledDaysDecoration;

  /// The text style of the current day
  final TextStyle todayTextStyle;

  /// The cell decoration of the current day.
  final BoxDecoration todayDecoration;

  /// The text style of selected day.
  final TextStyle selectedDayTextStyle;

  /// The cell decoration of selected day.
  final BoxDecoration selectedDayDecoration;

  /// The text style of leading date showing in the header.
  final TextStyle leadingDateTextStyle;

  /// The color of the page sliders.
  final Color slidersColor;

  /// The size of the page sliders.
  final double slidersSize;

  /// Defines the localized resource values used by the Material widgets.
  ///
  /// See also:
  ///
  ///  * [DefaultMaterialLocalizations], the default, English-only, implementation
  ///    of this interface.
  ///  * [GlobalMaterialLocalizations], which provides material localizations for
  ///    many languages.
  final MaterialLocalizations materialLocalizations;

  @override
  State<_DaysPicker> createState() => __DaysPickerState();
}

class __DaysPickerState extends State<_DaysPicker> {
  DateTime? _displayedMonth;
  DateTime? _selectedDate;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;
  double maxHeight = 52 * 6; // A 31 day month that starts on Saturday.

  @override
  void initState() {
    _displayedMonth = widget.initialDate;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, widget.initialDate),
    );
    if (isSevenRows(widget.initialDate.year, widget.initialDate.month,
        widget.initialDate.day)) {
      maxHeight = 52 * 7;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _DaysPicker oldWidget) {
    // there is no need to check for the displayed month because it changes via
    // page view and not the initial date.
    // but for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (DateUtils.dateOnly(oldWidget.initialDate) !=
        DateUtils.dateOnly(widget.initialDate)) {
      _pageController.jumpToPage(
        DateUtils.monthDelta(widget.minDate, widget.initialDate),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.minDate, index);

    return DaysView(
      key: ValueKey<DateTime>(month),
      currentDate: DateTime.now(),
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedMonth: month,
      selectedDate: _selectedDate,
      daysNameTextStyle: widget.daysNameTextStyle,
      enabledDaysTextStyle: widget.enabledDaysTextStyle,
      enabledDaysDecoration: widget.enabledDaysDecoration,
      disbaledDaysTextStyle: widget.disbaledDaysTextStyle,
      disbaledDaysDecoration: widget.disbaledDaysDecoration,
      todayDecoration: widget.todayDecoration,
      todayTextStyle: widget.todayTextStyle,
      selectedDayDecoration: widget.selectedDayDecoration,
      selectedDayTextStyle: widget.selectedDayTextStyle,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
        widget.onChange?.call(value);
      },
    );
  }

  void _handleMonthPageChanged(int monthPage) {
    final DateTime monthDate =
        DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);

    setState(() {
      _displayedMonth = monthDate;
      if (isSevenRows(monthDate.year, monthDate.month, monthDate.weekday)) {
        maxHeight = 52 * 7;
      } else {
        maxHeight = 52 * 6;
      }
    });
  }

  bool isSevenRows(int year, int month, int weekday) {
    final offset =
        DateUtils.firstDayOffset(year, month, widget.materialLocalizations);
    final daysCount = DateUtils.getDaysInMonth(year, month);

    // 30 & 5 => false
    // 31 & 5 => true
    // 30 & 6 => true
    // 31 & 6 => true
    if (offset == 5 && daysCount == 30) {
      return false;
    }

    if (offset >= 5 && daysCount >= 30) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Header(
          leadingDateTextStyle: widget.leadingDateTextStyle,
          slidersColor: widget.slidersColor,
          slidersSize: widget.slidersSize,
          onDateTap: () => widget.onLeadingDateTap?.call(),
          displayedDate: MaterialLocalizations.of(context)
              .formatMonthYear(_displayedMonth!)
              .replaceAll('٩', '9')
              .replaceAll('٨', '8')
              .replaceAll('٧', '7')
              .replaceAll('٦', '6')
              .replaceAll('٥', '5')
              .replaceAll('٤', '4')
              .replaceAll('٣', '3')
              .replaceAll('٢', '2')
              .replaceAll('١', '1')
              .replaceAll('٠', '0'),
          onNextPage: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          onPreviousPage: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: maxHeight,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            key: _pageViewKey,
            controller: _pageController,
            itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
            itemBuilder: _buildItems,
            onPageChanged: _handleMonthPageChanged,
          ),
        ),
      ],
    );
  }
}

/// A scrollable grid of months to allow picking a month.
///
/// The days picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view where the
///
class DaysPicker extends StatelessWidget {
  /// Creates a month picker.
  ///
  /// The [maxDate], [minDate], [initialDate] arguments
  /// must be non-null. The [minDate] must be after the [maxDate].
  DaysPicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
    this.onLeadingDateTap,
    this.onChange,
    required this.daysNameTextStyle,
    required this.enabledDaysTextStyle,
    required this.enabledDaysDecoration,
    required this.disbaledDaysTextStyle,
    required this.disbaledDaysDecoration,
    required this.todayTextStyle,
    required this.todayDecoration,
    required this.selectedDayTextStyle,
    required this.selectedDayDecoration,
    required this.leadingDateTextStyle,
    required this.slidersColor,
    required this.slidersSize,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// Called when the user picks a month.
  final ValueChanged<DateTime>? onChange;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The date which will be displayed on first opening.
  final DateTime initialDate;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of the days name.
  final TextStyle daysNameTextStyle;

  /// The text style of days which are selectable.
  final TextStyle enabledDaysTextStyle;

  /// The cell decoration of days which are selectable.
  final BoxDecoration enabledDaysDecoration;

  /// The text style of days which are not selectable.
  final TextStyle disbaledDaysTextStyle;

  /// The cell decoration of days which are not selectable.
  final BoxDecoration disbaledDaysDecoration;

  /// The text style of the current day
  final TextStyle todayTextStyle;

  /// The cell decoration of the current day.
  final BoxDecoration todayDecoration;

  /// The text style of selected day.
  final TextStyle selectedDayTextStyle;

  /// The cell decoration of selected day.
  final BoxDecoration selectedDayDecoration;

  /// The text style of leading date showing in the header.
  final TextStyle leadingDateTextStyle;

  /// The color of the page sliders.
  final Color slidersColor;

  /// The size of the page sliders.
  final double slidersSize;

  @override
  Widget build(BuildContext context) {
    return _DaysPicker(
      initialDate: initialDate,
      maxDate: maxDate,
      minDate: minDate,
      daysNameTextStyle: daysNameTextStyle,
      enabledDaysTextStyle: enabledDaysTextStyle,
      enabledDaysDecoration: enabledDaysDecoration,
      disbaledDaysTextStyle: disbaledDaysTextStyle,
      disbaledDaysDecoration: disbaledDaysDecoration,
      todayDecoration: todayDecoration,
      todayTextStyle: todayTextStyle,
      selectedDayDecoration: selectedDayDecoration,
      selectedDayTextStyle: selectedDayTextStyle,
      leadingDateTextStyle: leadingDateTextStyle,
      slidersColor: slidersColor,
      slidersSize: slidersSize,
      materialLocalizations: MaterialLocalizations.of(context),
      onChange: onChange,
      onLeadingDateTap: onLeadingDateTap,
    );
  }
}
