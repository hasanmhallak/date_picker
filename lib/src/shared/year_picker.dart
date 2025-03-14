import 'package:flutter/material.dart';

import 'device_orientation_builder.dart';
import 'header.dart';
import '../date/show_date_picker_dialog.dart';
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
  /// It will display a grid of years for the [initialDate]'s year. If [initialDate]
  /// is null, `DateTime.now()` will be used. If `DateTime.now()` does not fall within
  /// the valid range of [minDate] and [maxDate], it will fall back to the nearest
  /// valid date from `DateTime.now()`, selecting the [maxDate] if `DateTime.now()` is
  /// after the valid range, or [minDate] if before.
  ///
  /// The optional [onDateSelected] callback will be called if provided when a date
  /// is selected.
  ///
  /// The [minDate] is the earliest allowable date. The [maxDate] is the latest
  /// allowable date. [initialDate] and [selectedDate] must either fall between
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
    this.initialDate,
    this.currentDate,
    this.selectedDate,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration = const BoxDecoration(),
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration = const BoxDecoration(),
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.onLeadingDateTap,
    this.onDateSelected,
    this.leadingDateTextStyle,
    this.slidersColor,
    this.slidersSize,
    this.highlightColor,
    this.splashColor,
    this.splashRadius,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel = 'Previous Year',
    this.nextPageSemanticLabel = 'Next Year',
  }) {
    assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

    assert(
      () {
        if (initialDate == null) return true;
        final init = DateUtilsX.yearOnly(initialDate!);

        final min = DateUtilsX.yearOnly(minDate);

        return init.isAfter(min) || init.isAtSameMomentAs(min);
      }(),
      'initialDate $initialDate must be on or after minDate $minDate.',
    );
    assert(
      () {
        if (initialDate == null) return true;
        final init = DateUtilsX.yearOnly(initialDate!);

        final max = DateUtilsX.yearOnly(maxDate);
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
  /// Note that only year are considered. time, month and day fields are ignored.
  final DateTime? initialDate;

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

  /// Called when the user tap on the leading date.
  final VoidCallback? onLeadingDateTap;

  /// The text style of cells which are selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// defaults to empty [BoxDecoration].
  final BoxDecoration disabledCellsDecoration;

  /// The text style of the current date.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// defaults to circle stroke border with [ColorScheme.primary] color.
  final BoxDecoration? currentDateDecoration;

  /// The text style of selected cell.
  ///
  /// defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected cell.
  ///
  /// defaults to circle with [ColorScheme.primary] color.
  final BoxDecoration? selectedCellDecoration;

  /// The text style of leading date showing in the header.
  ///
  /// defaults to `18px` with a [FontWeight.bold]
  /// and [ColorScheme.primary] color.
  final TextStyle? leadingDateTextStyle;

  /// The color of the page sliders.
  ///
  /// defaults to [ColorScheme.primary] color.
  final Color? slidersColor;

  /// The size of the page sliders.
  ///
  /// defaults to `20px`.
  final double? slidersSize;

  /// The splash color of the ink response.
  ///
  /// defaults to the color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final Color? splashColor;

  /// The highlight color of the ink response when pressed.
  ///
  /// defaults to the color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final Color? highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Centring the leading date. e.g:
  ///
  /// <       December 2023      >
  ///
  final bool centerLeadingDate;

  /// Semantic label for button to go to the previous page.
  final String? previousPageSemanticLabel;

  /// Semantic label for button to go to the next page.
  final String? nextPageSemanticLabel;

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
    _selectedDate = widget.selectedDate != null
        ? DateUtilsX.yearOnly(widget.selectedDate!)
        : null;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YearsPicker oldWidget) {
    // for makeing debuging easy, we will navigate to the initial date again
    // if it changes.
    if (oldWidget.initialDate != widget.initialDate) {
      _pageController.jumpToPage(initialPageNumber);

      _displayedRange = DateTimeRange(
        start: DateTime(widget.minDate.year + initialPageNumber * 12),
        end: DateTime(widget.minDate.year + initialPageNumber * 12 - 1 + 12),
      );
    }

    if (oldWidget.selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate != null
          ? DateUtilsX.yearOnly(widget.selectedDate!)
          : null;
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
  int get pageCount =>
      ((widget.maxDate.year - widget.minDate.year + 1) / 12).ceil();

  int get initialPageNumber {
    final clampedInitailDate = DateUtilsX.clampDateToRange(
        max: widget.maxDate, min: widget.minDate, date: DateTime.now());
    final init = widget.initialDate ?? clampedInitailDate;

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    //
    //! enabled
    //
    //

    final TextStyle enabledCellsTextStyle = widget.enabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );

    final BoxDecoration enabledCellsDecoration = widget.enabledCellsDecoration;

    //
    //! disabled
    //
    //

    final TextStyle disabledCellsTextStyle = widget.disabledCellsTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface.withOpacity(0.30),
        );

    final BoxDecoration disbaledCellsDecoration =
        widget.disabledCellsDecoration;

    //
    //! current
    //
    //

    final TextStyle currentDateTextStyle = widget.currentDateTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.primary,
        );

    final BoxDecoration currentDateDecoration = widget.currentDateDecoration ??
        BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          shape: BoxShape.circle,
        );

    //
    //! selected.
    //
    //

    final TextStyle selectedCellTextStyle = widget.selectedCellTextStyle ??
        textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: colorScheme.onPrimary,
        );

    final BoxDecoration selectedCellDecoration =
        widget.selectedCellDecoration ??
            BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            );

    //
    //
    //
    //! header
    final leadingDateTextStyle = widget.leadingDateTextStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        );

    final slidersColor =
        widget.slidersColor ?? Theme.of(context).colorScheme.primary;

    final slidersSize = widget.slidersSize ?? 20;

    //
    //! splash
    final splashColor = widget.splashColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);

    final highlightColor = widget.highlightColor ??
        selectedCellDecoration.color?.withOpacity(0.3) ??
        colorScheme.primary.withOpacity(0.3);
    //
    //

    return DeviceOrientationBuilder(builder: (context, o) {
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
              previousPageSemanticLabel: widget.previousPageSemanticLabel,
              nextPageSemanticLabel: widget.nextPageSemanticLabel,
              centerLeadingDate: widget.centerLeadingDate,
              leadingDateTextStyle: leadingDateTextStyle,
              slidersColor: slidersColor,
              slidersSize: slidersSize,
              onDateTap: () => widget.onLeadingDateTap?.call(),
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
            Flexible(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
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
                    enabledCellsDecoration: enabledCellsDecoration,
                    enabledCellsTextStyle: enabledCellsTextStyle,
                    disabledCellsDecoration: disbaledCellsDecoration,
                    disabledCellsTextStyle: disabledCellsTextStyle,
                    currentDateDecoration: currentDateDecoration,
                    currentDateTextStyle: currentDateTextStyle,
                    selectedCellDecoration: selectedCellDecoration,
                    selectedCellTextStyle: selectedCellTextStyle,
                    highlightColor: highlightColor,
                    splashColor: splashColor,
                    splashRadius: widget.splashRadius,
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
