import 'package:flutter/material.dart';

import 'days_view.dart';
import 'header.dart';

class DaysPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime maxDate;
  final DateTime minDate;
  final VoidCallback? onLeadingDateTap;
  final ValueChanged<DateTime>? onChange;
  const DaysPicker({
    super.key,
    required this.initialDate,
    required this.maxDate,
    required this.minDate,
    this.onLeadingDateTap,
    this.onChange,
  });

  @override
  State<DaysPicker> createState() => _DaysPickerState();
}

class _DaysPickerState extends State<DaysPicker> {
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
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DaysPicker oldWidget) {
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
    if (DateUtils.getDaysInMonth(year, month) == 31 &&
        weekday == DateTime.saturday) {
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
          onDateTap: () => widget.onLeadingDateTap?.call(),
          displayedDate: MaterialLocalizations.of(context)
              .formatMonthYear(_displayedMonth!),
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
