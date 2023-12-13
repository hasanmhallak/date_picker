import 'package:flutter/material.dart';

import 'header.dart';
import 'month_view.dart';
import '../date/show_date_picker_dialog.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view.
///
///  * [showDateRangePicker], which creates a Dialog that contains a
///    [RangeDatePicker] and provides an optional compact view.
///
class MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// The [maxDate], [minDate], [initialDate] arguments
  /// must be non-null. The [minDate] must be after the [maxDate].
  MonthPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    required this.initialDate,
    required this.currentDate,
    required this.enabledMonthTextStyle,
    required this.enabledMonthDecoration,
    required this.disbaledMonthTextStyle,
    required this.disbaledMonthDecoration,
    required this.currentMonthTextStyle,
    required this.currentMonthDecoration,
    required this.selectedMonthTextStyle,
    required this.selectedMonthDecoration,
    required this.leadingDateTextStyle,
    required this.slidersColor,
    required this.slidersSize,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
    this.onLeadingDateTap,
    this.onChange,
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

  /// The current date. e.g (today)
  final DateTime currentDate;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of months which are selectable.
  final TextStyle enabledMonthTextStyle;

  /// The cell decoration of months which are selectable.
  final BoxDecoration enabledMonthDecoration;

  /// The text style of months which are not selectable.
  final TextStyle disbaledMonthTextStyle;

  /// The cell decoration of months which are not selectable.
  final BoxDecoration disbaledMonthDecoration;

  /// The text style of the current month
  final TextStyle currentMonthTextStyle;

  /// The cell decoration of the current month.
  final BoxDecoration currentMonthDecoration;

  /// The text style of selected month.
  final TextStyle selectedMonthTextStyle;

  /// The cell decoration of selected month.
  final BoxDecoration selectedMonthDecoration;

  /// The text style of leading date showing in the header.
  final TextStyle leadingDateTextStyle;

  /// The color of the page sliders.
  final Color slidersColor;

  /// The size of the page sliders.
  final double slidersSize;

  /// The splash color of the ink response.
  final Color splashColor;

  /// The highlight color of the ink response when pressed.
  final Color highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  DateTime? _displayedYear;
  DateTime? _selectedMonth;

  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  int get yearsCount => (widget.maxDate.year - widget.minDate.year) + 1;

  @override
  void initState() {
    _displayedYear = widget.initialDate;
    _pageController = PageController(
      initialPage: (widget.initialDate.year - widget.minDate.year),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MonthPicker oldWidget) {
    // for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (oldWidget.initialDate.year != widget.initialDate.year) {
      _pageController
          .jumpToPage((widget.initialDate.year - widget.minDate.year));
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime yearDate = DateTime(
        widget.minDate.year + index, widget.minDate.month, widget.minDate.day);

    return MonthView(
      key: ValueKey<DateTime>(yearDate),
      currentDate: widget.currentDate,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedYear: yearDate,
      selectedMonth: _selectedMonth,
      currentMonthDecoration: widget.currentMonthDecoration,
      currentMonthTextStyle: widget.currentMonthTextStyle,
      disbaledMonthDecoration: widget.disbaledMonthDecoration,
      disbaledMonthTextStyle: widget.disbaledMonthTextStyle,
      enabledMonthDecoration: widget.enabledMonthDecoration,
      enabledMonthTextStyle: widget.enabledMonthTextStyle,
      selectedMonthDecoration: widget.selectedMonthDecoration,
      selectedMonthTextStyle: widget.selectedMonthTextStyle,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      splashRadius: widget.splashRadius,
      onChanged: (value) {
        widget.onChange?.call(value);
        setState(() {
          _selectedMonth = value;
        });
      },
    );
  }

  void _handleYearPageChanged(int yearPage) {
    final DateTime yearDate = DateTime(widget.minDate.year + yearPage,
        widget.minDate.month, widget.minDate.day);

    setState(() {
      _displayedYear = yearDate;
    });
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
          displayedDate: _displayedYear!.year.toString(),
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
          height: 78 * 4,
          duration: const Duration(milliseconds: 200),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            key: _pageViewKey,
            controller: _pageController,
            itemCount: yearsCount,
            itemBuilder: _buildItems,
            onPageChanged: _handleYearPageChanged,
          ),
        ),
      ],
    );
  }
}
