import 'package:flutter/material.dart';

import '../shared/device_orientation_builder.dart';
import '../shared/header.dart';
import '../shared/utils.dart';
import '../theme/date_picker_plus_theme.dart';
import 'range_days_view.dart';

/// A scrollable grid of months to allow picking a day range.
class RangeDaysPicker extends StatefulWidget {
  RangeDaysPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.initialDate,
    this.currentDate,
    this.selectedStartDate,
    this.selectedEndDate,
    this.theme,
    this.onLeadingDateTap,
    this.onStartDateChanged,
    this.onEndDateChanged,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(
      () {
        if (initialDate == null) return true;
        final init = DateTime(initialDate!.year, initialDate!.month, initialDate!.day);

        final min = DateTime(minDate.year, minDate.month, minDate.day);

        return init.isAfter(min) || init.isAtSameMomentAs(min);
      }(),
      'initialDate $initialDate must be on or after minDate $minDate.',
    );
    assert(
      () {
        if (initialDate == null) return true;
        final init = DateTime(initialDate!.year, initialDate!.month, initialDate!.day);

        final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
        return init.isBefore(max) || init.isAtSameMomentAs(max);
      }(),
      'initialDate $initialDate must be on or before maxDate $maxDate.',
    );
  }

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? initialDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedEndDate;

  /// Called when the user picks a start date.
  final ValueChanged<DateTime>? onStartDateChanged;

  /// Called when the user picks an end date.
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

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DatePickerPlusTheme? theme;

  @override
  State<RangeDaysPicker> createState() => __RangeDaysPickerState();
}

class __RangeDaysPickerState extends State<RangeDaysPicker> {
  DateTime? _displayedMonth;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  @override
  void initState() {
    final clampedInitailDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedMonth = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, _displayedMonth!),
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RangeDaysPicker oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) {
      final clampedInitailDate =
          DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedMonth = DateUtils.dateOnly(widget.initialDate ?? clampedInitailDate);
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

  @override
  Widget build(BuildContext context) {
    final defaultTheme = DatePickerPlusTheme.defaults(context);
    final contextTheme = Theme.of(context).extension<DatePickerPlusTheme>();
    final theme = defaultTheme.merge(contextTheme).merge(widget.theme);

    final bool isEnabled = theme.isEnabled ?? true;

    return PickerDeviceOrientationBuilder(builder: (context, o) {
      late final Size size;
      switch (o) {
        case Orientation.portrait:
          size = const Size(328.0, 402.0);
          break;
        case Orientation.landscape:
          size = const Size(328.0, 300.0);
          break;
      }

      return LimitedBox(
        maxHeight: size.height,
        maxWidth: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(
              theme: theme.headerTheme,
              isEnabled: isEnabled,
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
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                physics: isEnabled ? null : const NeverScrollableScrollPhysics(),
                key: _pageViewKey,
                controller: _pageController,
                itemCount: DateUtils.monthDelta(widget.minDate, widget.maxDate) + 1,
                onPageChanged: (monthPage) {
                  final DateTime monthDate = DateUtils.addMonthsToMonthDate(widget.minDate, monthPage);

                  setState(() {
                    _displayedMonth = monthDate;
                  });
                },
                itemBuilder: (context, index) {
                  final DateTime month = DateUtils.addMonthsToMonthDate(widget.minDate, index);

                  return RangeDaysView(
                    key: ValueKey<DateTime>(month),
                    currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                    minDate: DateUtils.dateOnly(widget.minDate),
                    maxDate: DateUtils.dateOnly(widget.maxDate),
                    displayedMonth: month,
                    selectedEndDate:
                        widget.selectedEndDate == null ? null : DateUtils.dateOnly(widget.selectedEndDate!),
                    selectedStartDate:
                        widget.selectedStartDate == null ? null : DateUtils.dateOnly(widget.selectedStartDate!),
                    theme: theme,
                    onEndDateChanged: (value) => widget.onEndDateChanged?.call(value),
                    onStartDateChanged: (value) => widget.onStartDateChanged?.call(value),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
