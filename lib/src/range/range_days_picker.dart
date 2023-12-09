import 'package:flutter/material.dart';

import '../shared/header.dart';
import 'range_days_view.dart';

/// A scrollable grid of months to allow picking a day range.
class RangeDaysPicker extends StatefulWidget {
  RangeDaysPicker({
    super.key,
    required this.currentDate,
    required this.maxDate,
    required this.minDate,
    required this.initailDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disbaledCellsTextStyle,
    required this.disbaledCellsDecoration,
    required this.currentTextStyle,
    required this.currentDecoration,
    required this.selectedCellsTextStyle,
    required this.selectedCellsDecoration,
    required this.selectedStartCellTextStyle,
    required this.selectedStartCellDecoration,
    required this.selectedEndCellTextStyle,
    required this.selectedEndCellDecoration,
    required this.singelSelectedCellTextStyle,
    required this.singelSelectedCellDecoration,
    required this.onLeadingDateTap,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.leadingDateTextStyle,
    required this.slidersColor,
    required this.slidersSize,
    required this.highlightColor,
    required this.splashColor,
    required this.splashRadius,
    required this.materialLocalizations,
  })  : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate"),
        assert(() {
          if (selectedStartDate == null) return true;
          return (selectedStartDate.isAfter(minDate) ||
                  selectedStartDate.isAtSameMomentAs(minDate)) &&
              (selectedStartDate.isBefore(maxDate) ||
                  selectedStartDate.isAtSameMomentAs(maxDate));
        }(),
            "selected start date should be in the range of min date & max date"),
        assert(() {
          if (selectedEndDate == null) return true;
          return (selectedEndDate.isAfter(minDate) ||
                  selectedEndDate.isAtSameMomentAs(minDate)) &&
              (selectedEndDate.isBefore(maxDate) ||
                  selectedEndDate.isAtSameMomentAs(maxDate));
        }(), "selected end date should be in the range of min date & max date");

  /// Called when the user picks a start date.
  final ValueChanged<DateTime> onStartDateChanged;

  /// Called when the user picks an end date.
  final ValueChanged<DateTime> onEndDateChanged;

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedEndDate;

  /// The current date. e.g (today)
  final DateTime currentDate;

  /// The date which will be displayed on first opening.
  final DateTime initailDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of the days name.
  final TextStyle daysOfTheWeekTextStyle;

  /// The text style of days which are selectable.
  final TextStyle enabledCellsTextStyle;

  /// The cell decoration of days which are selectable.
  final BoxDecoration enabledCellsDecoration;

  /// The text style of days which are not selectable.
  final TextStyle disbaledCellsTextStyle;

  /// The cell decoration of days which are not selectable.
  final BoxDecoration disbaledCellsDecoration;

  /// The text style of the current day
  final TextStyle currentTextStyle;

  /// The cell decoration of the current day.
  final BoxDecoration currentDecoration;

  /// The text style of selected day.
  final TextStyle selectedCellsTextStyle;

  /// The cell decoration of selected day.
  final BoxDecoration selectedCellsDecoration;

  /// The text style of selected start cell of the range.
  final TextStyle selectedStartCellTextStyle;

  /// The cell decoration of selected start cell of the range.
  final BoxDecoration selectedStartCellDecoration;

  /// The text style of selected end cell of the range.
  final TextStyle selectedEndCellTextStyle;

  /// The cell decoration of selected end cell of the range.
  final BoxDecoration selectedEndCellDecoration;

  /// The text style of a single selected cell.
  final TextStyle singelSelectedCellTextStyle;

  /// The cell decoration of a single selected cell.
  final BoxDecoration singelSelectedCellDecoration;

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

  /// Defines the localized resource values used by the Range Picker widget.
  ///
  /// See also:
  ///
  ///  * [DefaultMaterialLocalizations], the default, English-only, implementation
  ///    of this interface.
  ///  * [GlobalMaterialLocalizations], which provides material localizations for
  ///    many languages.
  final MaterialLocalizations materialLocalizations;

  @override
  State<RangeDaysPicker> createState() => __RangeDaysPickerState();
}

class __RangeDaysPickerState extends State<RangeDaysPicker> {
  DateTime? _displayedMonth;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;
  double maxHeight = 52 * 6; // A 31 day month that starts on Saturday.

  @override
  void initState() {
    _displayedMonth = widget.initailDate;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, _displayedMonth!),
    );
    if (isSevenRows(
        _displayedMonth!.year, _displayedMonth!.month, _displayedMonth!.day)) {
      maxHeight = 52 * 7;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RangeDaysPicker oldWidget) {
    // there is no need to check for the displayed month because it changes via
    // page view and not the initial date.
    // but for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (DateUtils.dateOnly(oldWidget.initailDate) !=
        DateUtils.dateOnly(widget.initailDate)) {
      _displayedMonth = widget.initailDate;
      _pageController.jumpToPage(
        DateUtils.monthDelta(widget.minDate, _displayedMonth!),
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
      currentDate: widget.currentDate,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      displayedMonth: month,
      selectedEndDate: widget.selectedEndDate,
      selectedStartDate: widget.selectedStartDate,
      daysOfTheWeekTextStyle: widget.daysOfTheWeekTextStyle,
      enabledCellsTextStyle: widget.enabledCellsTextStyle,
      enabledCellsDecoration: widget.enabledCellsDecoration,
      disbaledCellsTextStyle: widget.disbaledCellsTextStyle,
      disbaledCellsDecoration: widget.disbaledCellsDecoration,
      currentDateDecoration: widget.currentDecoration,
      currentDateTextStyle: widget.currentTextStyle,
      selectedCellsDecoration: widget.selectedCellsDecoration,
      selectedCellsTextStyle: widget.selectedCellsTextStyle,
      selectedStartCellTextStyle: widget.selectedStartCellTextStyle,
      selectedStartCellDecoration: widget.selectedStartCellDecoration,
      selectedEndCellTextStyle: widget.selectedEndCellTextStyle,
      selectedEndCellDecoration: widget.selectedEndCellDecoration,
      singelSelectedCellTextStyle: widget.singelSelectedCellTextStyle,
      singelSelectedCellDecoration: widget.singelSelectedCellDecoration,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      splashRadius: widget.splashRadius,
      onEndDateChanged: widget.onEndDateChanged,
      onStartDateChanged: widget.onStartDateChanged,
    );
  }

  void _handleMonthPageChanged(int monthPage) {
    final DateTime monthDate =
        DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);

    final isSeven =
        isSevenRows(monthDate.year, monthDate.month, monthDate.weekday);

    setState(() {
      _displayedMonth = monthDate;
      if (isSeven) {
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
    if (offset == 5 && daysCount == 30) {
      return false;
    }

    // 31 & 5 => true
    // 30 & 6 => true
    // 31 & 6 => true
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
          displayedDate: widget.materialLocalizations
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
