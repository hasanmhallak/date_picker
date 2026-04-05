import 'package:flutter/material.dart';

import '../theme/date_picker_plus_theme.dart';
import 'device_orientation_builder.dart';
import 'header.dart';
import '../date/show_date_picker_dialog.dart';
import 'types.dart';
import 'utils.dart';
import 'year_view.dart';

/// Displays a grid of years which allows the user to select a
/// date.
///
/// Years are arranged in a 3 x 4 rectangular grid containing 12 years
/// with one column for each year. Controls are provided to change the
/// year range that the grid is showing.
///
/// The year picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///
class YearsPicker extends StatefulWidget {
  /// Creates a year picker.
  ///
  /// It will display a grid of years for the [displayedDate]'s year. If [displayedDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
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
  /// their year are considered. Their time, month and day fields are ignored.
  YearsPicker({
    super.key,
    required this.minDate,
    required this.maxDate,
    this.displayedDate,
    this.currentDate,
    this.selectedDate,
    this.theme,
    this.cellBuilder,
    this.onLeadingDateTap,
    this.onDateSelected,
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(
      () {
        if (displayedDate == null) return true;
        final init = DateUtilsX.yearOnly(displayedDate!);

        final min = DateUtilsX.yearOnly(minDate);

        return init.isAfter(min) || init.isAtSameMomentAs(min);
      }(),
      'displayedDate $displayedDate must be on or after minDate $minDate.',
    );
    assert(
      () {
        if (displayedDate == null) return true;
        final init = DateUtilsX.yearOnly(displayedDate!);

        final max = DateUtilsX.yearOnly(maxDate);
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
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime? displayedDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime? currentDate;

  /// The initially selected date when the picker is first opened.
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime? selectedDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime maxDate;

  /// Optional builder for customizing individual cells.
  final CellBuilder? cellBuilder;

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final DatePickerPlusTheme? theme;

  @override
  State<YearsPicker> createState() => _YearsPickerState();
}

class _YearsPickerState extends State<YearsPicker> {
  DateTimeRange? _displayedRange;
  DateTime? _selectedDate;

  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: initialPageNumber);

    _displayedRange = DateTimeRange(
      start: DateTime(widget.minDate.year + initialPageNumber * 12),
      end: DateTime(widget.minDate.year + initialPageNumber * 12 - 1 + 12),
    );
    _selectedDate = widget.selectedDate != null ? DateUtilsX.yearOnly(widget.selectedDate!) : null;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YearsPicker oldWidget) {
    // for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (oldWidget.displayedDate != widget.displayedDate) {
      _pageController.jumpToPage(initialPageNumber);

      _displayedRange = DateTimeRange(
        start: DateTime(widget.minDate.year + initialPageNumber * 12),
        end: DateTime(widget.minDate.year + initialPageNumber * 12 - 1 + 12),
      );
    }

    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null ? DateUtilsX.yearOnly(widget.selectedDate!) : null;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Returns the number of pages needed to fullfil the date range
  /// between [minDate] and [maxDate].
  ///
  /// Each page will contains 12 years in a 3 x 4 grid.
  int get pageCount => ((widget.maxDate.year - widget.minDate.year + 1) / 12).ceil();

  int get initialPageNumber {
    final clampedDisplayedDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    final init = widget.displayedDate ?? clampedDisplayedDate;

    final page = ((init.year - widget.minDate.year + 1) / 12).ceil() - 1;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(
              theme: theme.headerTheme,
              isEnabled: isEnabled,
              onDateTap: () => widget.onLeadingDateTap?.call(),
              displayedDate: '${_displayedRange?.start.year} - ${_displayedRange?.end.year}',
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
            Flexible(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                physics: isEnabled ? null : const NeverScrollableScrollPhysics(),
                key: _pageViewKey,
                controller: _pageController,
                itemCount: pageCount,
                onPageChanged: (yearPage) {
                  setState(() {
                    _displayedRange = calculateDateRange(yearPage);
                  });
                },
                itemBuilder: (context, index) {
                  final yearRange = calculateDateRange(index);

                  return YearView(
                    key: ValueKey<DateTimeRange>(yearRange),
                    currentDate: widget.currentDate != null
                        ? DateUtilsX.yearOnly(widget.currentDate!)
                        : DateUtilsX.yearOnly(DateTime.now()),
                    maxDate: DateUtilsX.yearOnly(widget.maxDate),
                    minDate: DateUtilsX.yearOnly(widget.minDate),
                    displayedYearRange: yearRange,
                    selectedDate: _selectedDate,
                    cellBuilder: widget.cellBuilder,
                    theme: theme.yearsPickerTheme,
                    isEnabled: isEnabled,
                    onChanged: (value) {
                      final selected = DateUtilsX.yearOnly(value);
                      widget.onDateSelected?.call(selected);
                      setState(() {
                        _selectedDate = selected;
                      });
                    },
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
