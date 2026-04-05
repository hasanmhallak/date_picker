import 'package:flutter/material.dart';

import '../theme/date_picker_plus_theme.dart';
import 'device_orientation_builder.dart';
import 'header.dart';
import 'month_view.dart';
import 'types.dart';
import 'utils.dart';
import '../date/show_date_picker_dialog.dart';

/// Displays a grid of months for a given year and allows the user to select a
/// date.
///
/// Months are arranged in a rectangular grid with one column for each month of the
/// year. Controls are provided to change the year that the grid is
/// showing.
///
/// The month picker widget is rarely used directly. Instead, consider using
/// [showDatePickerDialog], which will create a dialog that uses this.
///
/// See also:
///
///  * [showDatePickerDialog], which creates a Dialog that contains a
///    [DatePicker].
///
class MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  ///
  /// It will display a grid of months for the [displayedDate]'s year. If [displayedDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The month indicated by [selectedDate] will be selected if provided.
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
  /// their year & month are considered. Their time & day fields are ignored.
  MonthPicker({
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
        final init = DateUtilsX.monthOnly(displayedDate!);

        final min = DateUtilsX.monthOnly(minDate);

        return init.isAfter(min) || init.isAtSameMomentAs(min);
      }(),
      'displayedDate $displayedDate must be on or after minDate $minDate.',
    );
    assert(
      () {
        if (displayedDate == null) return true;
        final init = DateUtilsX.monthOnly(displayedDate!);

        final max = DateUtilsX.monthOnly(maxDate);
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
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime? displayedDate;

  /// The date to which the picker will consider as current date. e.g (today).
  /// If not specified, the picker will default to `DateTime.now()` date.
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime? currentDate;

  /// The initially selected date when the picker is first opened.
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime? selectedDate;

  /// Called when the user picks a date.
  final ValueChanged<DateTime>? onDateSelected;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  ///
  /// Note that only year & month are considered. time & day fields are ignored.
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
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  DateTime? _displayedYear;
  DateTime? _selectedDate;

  final GlobalKey _pageViewKey = GlobalKey();
  late final PageController _pageController;

  int get yearsCount => (widget.maxDate.year - widget.minDate.year) + 1;

  @override
  void initState() {
    final clampedDisplayedDate =
        DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    _displayedYear = DateUtilsX.yearOnly(widget.displayedDate ?? clampedDisplayedDate);

    _selectedDate = widget.selectedDate != null ? DateUtilsX.monthOnly(widget.selectedDate!) : null;
    _pageController = PageController(
      initialPage: (_displayedYear!.year - widget.minDate.year),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MonthPicker oldWidget) {
    if (oldWidget.displayedDate != widget.displayedDate) {
      final clampedDisplayedDate =
          DateUtilsX.clampDateToRange(max: widget.maxDate, min: widget.minDate, date: DateTime.now());
      _displayedYear = DateUtilsX.yearOnly(widget.displayedDate ?? clampedDisplayedDate);
      _pageController.jumpToPage(_displayedYear!.year - widget.minDate.year);
    }

    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null ? DateUtilsX.monthOnly(widget.selectedDate!) : null;
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
    final bool isEnabled = widget.theme?.isEnabled ?? true;

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
            Expanded(
              child: Padding(
                padding: theme.monthsPickerTheme?.padding ?? EdgeInsets.zero,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: isEnabled ? null : const NeverScrollableScrollPhysics(),
                  key: _pageViewKey,
                  controller: _pageController,
                  itemCount: yearsCount,
                  onPageChanged: (yearPage) {
                    final DateTime year = DateTime(
                      widget.minDate.year + yearPage,
                    );

                    setState(() {
                      _displayedYear = year;
                    });
                  },
                  itemBuilder: (context, index) {
                    final DateTime year = DateTime(
                      widget.minDate.year + index,
                    );

                    return MonthView(
                      key: ValueKey<DateTime>(year),
                      currentDate: widget.currentDate != null
                          ? DateUtilsX.monthOnly(widget.currentDate!)
                          : DateUtilsX.monthOnly(DateTime.now()),
                      maxDate: DateUtilsX.monthOnly(widget.maxDate),
                      minDate: DateUtilsX.monthOnly(widget.minDate),
                      displayedDate: year,
                      selectedDate: _selectedDate,
                      cellBuilder: widget.cellBuilder,
                      theme: theme.monthsPickerTheme,
                      isEnabled: isEnabled,
                      onChanged: (value) {
                        final selected = DateUtilsX.monthOnly(value);
                        widget.onDateSelected?.call(selected);
                        setState(() {
                          _selectedDate = selected;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
