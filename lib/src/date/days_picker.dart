import 'package:flutter/material.dart';

import '../shared/device_orientation_builder.dart';
import '../shared/types.dart';
import '../shared/utils.dart';
import '../theme/date_picker_plus_theme.dart';
import 'days_view.dart';
import '../shared/header.dart';
import 'show_date_picker_dialog.dart';

/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the month that the grid is
/// showing.
///
/// The date picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///
class DaysPicker extends StatefulWidget {
  /// Creates a days picker.
  ///
  /// It will display a grid of days for the [displayedDate]'s month. If [displayedDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The day indicated by [selectedDate] will be selected if provided.
  ///
  /// The optional [onDateSelected] callback will be called if provided when a date
  /// is selected.
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [displayedDate] and [selectedDate] must either fall between
  /// these dates, or be equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// For each of these [DateTime] parameters, only
  /// their dates are considered. Their time fields are ignored.
  DaysPicker({
    super.key,
    required this.maxDate,
    required this.minDate,
    this.displayedDate,
    this.currentDate,
    this.selectedDate,
    this.theme,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.onDisplayedMonthChanged,
    this.disabledDayPredicate,
    this.cellBuilder,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");
    assert(
      () {
        if (displayedDate == null) return true;
        final init = DateTime(displayedDate!.year, displayedDate!.month, displayedDate!.day);

        final min = DateTime(minDate.year, minDate.month, minDate.day);

        return init.isAfter(min) || init.isAtSameMomentAs(min);
      }(),
      'displayedDate $displayedDate must be on or after minDate $minDate.',
    );
    assert(
      () {
        if (displayedDate == null) return true;
        final init = DateTime(displayedDate!.year, displayedDate!.month, displayedDate!.day);

        final max = DateTime(maxDate.year, maxDate.month, maxDate.day);
        return init.isBefore(max) || init.isAtSameMomentAs(max);
      }(),
      'displayedDate $displayedDate must be on or before maxDate $maxDate.',
    );
  }

  /// The date which will be displayed on first opening. If not specified, the picker
  /// will default to `DateTime.now()`. If `DateTime.now()` does not fall within the
  /// valid range of [minDate] and [maxDate], it will automatically adjust to the nearest
  /// valid date, selecting [maxDate] if `DateTime.now()` is after the valid range, or
  /// [minDate] if it is before.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? displayedDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? currentDate;

  /// The initially selected date when the picker is first opened.
  ///
  /// Note that only dates are considered. time fields are ignored.
  final DateTime? selectedDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// Called when the displayed month changes.
  ///
  /// This is called once during initialization with the initial month,
  /// and subsequently whenever the user swipes between pages.
  ///
  /// The [DateTime] passed is the first day of the displayed month.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

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

  /// A predicate function used to determine if a given day should be disabled.
  final DatePredicate? disabledDayPredicate;

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DatePickerPlusTheme? theme;

  @override
  State<DaysPicker> createState() => _DaysPickerState();
}

class _DaysPickerState extends State<DaysPicker> {
  DateTime? _displayedMonth;
  DateTime? _selectedDate;
  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  @override
  void initState() {
    final clampedDisplayedDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedMonth = DateUtils.dateOnly(widget.displayedDate ?? clampedDisplayedDate);
    _selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(widget.minDate, _displayedMonth!),
    );
    super.initState();
    widget.onDisplayedMonthChanged?.call(
      DateTime(_displayedMonth!.year, _displayedMonth!.month, 1),
    );
  }

  @override
  void didUpdateWidget(covariant DaysPicker oldWidget) {
    if (oldWidget.displayedDate != widget.displayedDate) {
      final clampedDisplayedDate =
          DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedMonth = DateUtils.dateOnly(widget.displayedDate ?? clampedDisplayedDate);

      _pageController.jumpToPage(
        DateUtils.monthDelta(widget.minDate, _displayedMonth!),
      );
    }

    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null ? DateUtils.dateOnly(widget.selectedDate!) : null;
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

    return PickerDeviceOrientationBuilder(
      builder: (context, o) {
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
                    widget.onDisplayedMonthChanged?.call(monthDate);
                  },
                  itemBuilder: (context, index) {
                    final DateTime month = DateUtils.addMonthsToMonthDate(widget.minDate, index);

                    return DaysView(
                      key: ValueKey<DateTime>(month),
                      currentDate: DateUtils.dateOnly(widget.currentDate ?? DateTime.now()),
                      maxDate: DateUtils.dateOnly(widget.maxDate),
                      minDate: DateUtils.dateOnly(widget.minDate),
                      displayedMonth: month,
                      selectedDate: _selectedDate,
                      disabledDayPredicate: widget.disabledDayPredicate,
                      cellBuilder: widget.cellBuilder,
                      theme: theme.daysPickerTheme,
                      isEnabled: isEnabled,
                      onChanged: (value) {
                        setState(() {
                          _selectedDate = value;
                        });
                        widget.onDateSelected?.call(value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
