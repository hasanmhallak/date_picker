import 'package:datePicker/src/year_view.dart';
import 'package:flutter/material.dart';

import 'header.dart';
import 'show_date_picker_dialog.dart';

/// A scrollable grid of years to allow picking a year.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker] and provides an optional compact view where the
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
    this.enabledYearColor,
    this.disbaledYearColor,
    this.currentYearColor,
    this.selectedYearColor,
    this.selectedYearFillColor,
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

  /// The color of enabled month which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledYearColor;

  /// The color of disabled months which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledYearColor;

  /// The color of the current month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? currentYearColor;

  /// The color of the selected month.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedYearColor;

  /// The fill color of the selected month.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? selectedYearFillColor;

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
      currentYearColor: widget.currentYearColor,
      disbaledYearColor: widget.disbaledYearColor,
      enabledYearColor: widget.enabledYearColor,
      selectedYearColor: widget.selectedYearColor,
      selectedYearFillColor: widget.selectedYearFillColor,
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
