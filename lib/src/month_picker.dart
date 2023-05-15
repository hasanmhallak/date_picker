import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'header.dart';
import 'month_view.dart';

/// A scrollable grid of months to allow picking a month.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [DatePicker] which create full date picker.
///
/// See also:
///
///  * [DatePicker], which provides a Material Design date picker
///    interface.
///
class MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// The [maxDate], [minDate], [initialDate] arguments
  /// must be non-null. The [minDate] must be after the [maxDate].
  MonthPicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
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

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

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
    final DateTime yearDate = widget.minDate.add(Duration(days: 365 * index));

    return MonthView(
      key: ValueKey<DateTime>(yearDate),
      currentDate: DateTime.now(),
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedYear: yearDate,
      selectedMonth: _selectedMonth,
      onChanged: (value) {
        widget.onChange?.call(value);
        setState(() {
          _selectedMonth = value;
        });
      },
    );
  }

  void _handleYearPageChanged(int yearPage) {
    final DateTime yearDate =
        widget.minDate.add(const Duration(days: 365) * yearPage);

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
          onDateTap: () => widget.onLeadingDateTap?.call(),
          displayedDate: DateFormat(
            'yyy',
            Localizations.localeOf(context).toString(),
          ).format(_displayedYear!),
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
