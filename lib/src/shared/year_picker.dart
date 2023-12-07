import 'package:flutter/material.dart';

import 'header.dart';
import '../date/show_date_picker_dialog.dart';
import 'year_view.dart';

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view.
///
///  * [showDateRangePicker], which creates a Dialog that contains a
///    [RangeDatePicker] and provides an optional compact view.
///
class YearsPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// The [maxDate], [minDate], [initialDate] arguments
  /// must be non-null. The [minDate] must be after the [maxDate].
  YearsPicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
    this.onChange,
    required this.enabledYearTextStyle,
    required this.enabledYearDecoration,
    required this.disbaledYearTextStyle,
    required this.disbaledYearDecoration,
    required this.currentYearTextStyle,
    required this.currentYearDecoration,
    required this.selectedYearTextStyle,
    required this.selectedYearDecoration,
    required this.leadingDateTextStyle,
    required this.slidersColor,
    required this.slidersSize,
    required this.highlightColor,
    required this.splashColor,
    this.splashRadius,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// Called when the user picks a year.
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

  /// The text style of years which are selectable.
  final TextStyle enabledYearTextStyle;

  /// The cell decoration of years which are selectable.
  final BoxDecoration enabledYearDecoration;

  /// The text style of years which are not selectable.
  final TextStyle disbaledYearTextStyle;

  /// The cell decoration of years which are not selectable.
  final BoxDecoration disbaledYearDecoration;

  /// The text style of the current year
  final TextStyle currentYearTextStyle;

  /// The cell decoration of the current year.
  final BoxDecoration currentYearDecoration;

  /// The text style of selected year.
  final TextStyle selectedYearTextStyle;

  /// The cell decoration of selected year.
  final BoxDecoration selectedYearDecoration;

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
  State<YearsPicker> createState() => _YearsPickerState();
}

class _YearsPickerState extends State<YearsPicker> {
  DateTime? _selectedYear;
  DateTimeRange? _displayedRange;

  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  /// Returns the number of pages needed to fullfil the date range
  /// between [minDate] and [maxDate].
  ///
  /// Each page will contains 12 years in a 3 x 4 grid.
  int get pageCount =>
      ((widget.maxDate.year - widget.minDate.year + 1) / 12).ceil();

  int get initialPageNumber {
    final page =
        ((widget.initialDate.year - widget.minDate.year + 1) / 12).ceil() - 1;
    if (page < 0) return 0;
    return page;
  }

  DateTimeRange calculateDateRange(int pageIndex) {
    return DateTimeRange(
      start: DateTime(widget.minDate.year + pageIndex * 12),
      end: DateTime(widget.minDate.year + pageIndex * 12 + 12 - 1),
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: initialPageNumber);

    _displayedRange = DateTimeRange(
      start: DateTime(widget.minDate.year + initialPageNumber * 12),
      end: DateTime(widget.minDate.year + initialPageNumber * 12 - 1 + 12),
    );
    // _selectedYear = widget.selectedDate;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YearsPicker oldWidget) {
    // for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (oldWidget.initialDate.year != widget.initialDate.year) {
      _pageController.jumpToPage(initialPageNumber);

      _displayedRange = DateTimeRange(
        start: DateTime(widget.minDate.year + initialPageNumber * 12),
        end: DateTime(widget.minDate.year + initialPageNumber * 12 - 1 + 12),
      );
    }

    // if (oldWidget.selectedDate != widget.selectedDate) {
    //   _selectedYear = widget.selectedDate;
    // }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildItems(BuildContext context, int index) {
    final yearRange = calculateDateRange(index);

    return YearView(
      key: ValueKey<DateTimeRange>(yearRange),
      currentDate: DateTime.now(),
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedYearRange: yearRange,
      selectedYear: _selectedYear,
      currentYearDecoration: widget.currentYearDecoration,
      currentYearTextStyle: widget.currentYearTextStyle,
      disbaledYearDecoration: widget.disbaledYearDecoration,
      disbaledYearTextStyle: widget.disbaledYearTextStyle,
      enabledYearDecoration: widget.enabledYearDecoration,
      enabledYearTextStyle: widget.enabledYearTextStyle,
      selectedYearDecoration: widget.selectedYearDecoration,
      selectedYearTextStyle: widget.selectedYearTextStyle,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      splashRadius: widget.splashRadius,
      onChanged: (value) {
        widget.onChange?.call(value);
        setState(() {
          _selectedYear = value;
        });
      },
    );
  }

  void _handleYearPageChanged(int yearPage) {
    setState(() {
      _displayedRange = calculateDateRange(yearPage);
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
          onDateTap: () {},
          displayedDate:
              '${_displayedRange?.start.year} - ${_displayedRange?.end.year}',
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
            itemCount: pageCount,
            itemBuilder: _buildItems,
            onPageChanged: _handleYearPageChanged,
          ),
        ),
      ],
    );
  }
}
