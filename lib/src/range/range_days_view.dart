import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

import '../shared/picker_grid_delegate.dart';

const double _dayPickerRowHeight = 52.0;

/// Displays the days of a given month and allows choosing days range.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class RangeDaysView extends StatelessWidget {
  /// Displays the days of a given month and allows choosing  days range.
  ///
  /// The days are arranged in a rectangular grid with one column for each day of
  /// the week.
  RangeDaysView({
    super.key,
    required this.currentDate,
    required this.minDate,
    required this.maxDate,
    required this.selectedStartDate,
    required this.selectedEndDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.displayedMonth,
    required this.daysOfTheWeekTextStyle,
    required this.enabledCellsTextStyle,
    required this.enabledCellsDecoration,
    required this.disbaledCellsTextStyle,
    required this.disbaledCellsDecoration,
    required this.currentDateTextStyle,
    required this.currentDateDecoration,
    required this.selectedCellsTextStyle,
    required this.selectedCellsDecoration,
    required this.singelSelectedCellTextStyle,
    required this.singelSelectedCellDecoration,
    required this.highlightColor,
    required this.splashColor,
    required this.splashRadius,
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

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedStartDate;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker
  final DateTime? selectedEndDate;

  /// The current date. e.g (today)
  final DateTime currentDate;

  /// Called when the user picks a start date.
  final ValueChanged<DateTime> onStartDateChanged;

  /// Called when the user picks an end date.
  final ValueChanged<DateTime> onEndDateChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maxDate].
  final DateTime minDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minDate].
  final DateTime maxDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// The text style of the week days name.
  final TextStyle daysOfTheWeekTextStyle;

  /// The text style of cells which are selectable.
  final TextStyle enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  final BoxDecoration enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  final TextStyle disbaledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  final BoxDecoration disbaledCellsDecoration;

  /// The text style of a single selected cell and the
  /// leading/trailing cell of a selected range.
  final TextStyle singelSelectedCellTextStyle;

  /// The cell decoration of a single selected cell and the
  /// leading/trailing cell of a selected range.
  final BoxDecoration singelSelectedCellDecoration;

  /// The text style of the current date.
  final TextStyle currentDateTextStyle;

  /// The cell decoration of the current date.
  final BoxDecoration currentDateDecoration;

  /// The text style of selected cells in a range.
  final TextStyle selectedCellsTextStyle;

  /// The cell decoration of selected cells in a range.
  final BoxDecoration selectedCellsDecoration;

  /// The splash color of the ink response.
  final Color splashColor;

  /// The highlight color of the ink response when pressed.
  final Color highlightColor;

  /// The radius of the ink splash.
  final double? splashRadius;

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  ///     ┌ Sunday is the first day of week in the US (en_US)
  ///     |
  ///     S M T W T F S  ← the returned list contains these widgets
  ///     _ _ _ _ _ 1 2
  ///     3 4 5 6 7 8 9
  ///
  ///     ┌ But it's Monday in the UK (en_GB)
  ///     |
  ///     M T W T F S S  ← the returned list contains these widgets
  ///     _ _ _ _ 1 2 3
  ///     4 5 6 7 8 9 10
  ///
  List<Widget> _dayHeaders(
    TextStyle headerStyle,
    Locale locale,
    MaterialLocalizations localizations,
  ) {
    final List<Widget> result = <Widget>[];
    final weekdayNames =
        intl.DateFormat('', locale.toString()).dateSymbols.SHORTWEEKDAYS;

    // Monday is represented by 1 and Sunday is represented by 7.
    // but MaterialLocalizations does not have 7 instead the sunday is 0.
    // final int todayIndex = currentDate.weekday == 7 ? 0 : currentDate.weekday;
    // TODO: add custom firstDayOfWeekIndex.
    for (int i = localizations.firstDayOfWeekIndex; true; i = (i + 1) % 7) {
      // to save space in arabic as arabic don't has short week days.
      final String weekday = weekdayNames[i].replaceFirst('ال', '');
      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday.toUpperCase(),
              style: daysOfTheWeekTextStyle,
            ),
          ),
        ),
      );
      if (i == (localizations.firstDayOfWeekIndex - 1) % 7) {
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    //
    //
    //
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(
      daysOfTheWeekTextStyle,
      Localizations.localeOf(context),
      MaterialLocalizations.of(context),
    );

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled =
            dayToBuild.isAfter(maxDate) || dayToBuild.isBefore(minDate);

        final isRangeSelected =
            selectedStartDate != null && selectedEndDate != null;

        final isSingleCellSelected = (selectedStartDate != null &&
                selectedEndDate == null &&
                dayToBuild == selectedStartDate) &&
            !isRangeSelected;

        final bool isWithinRange = isRangeSelected &&
            dayToBuild.isAfter(selectedStartDate!) &&
            dayToBuild.isBefore(selectedEndDate!);

        final isStartDate = DateUtils.isSameDay(selectedStartDate, dayToBuild);

        final isEndDate = DateUtils.isSameDay(selectedEndDate, dayToBuild);

        final bool isCurrent = DateUtils.isSameDay(currentDate, dayToBuild);
        //
        //
        BoxDecoration decoration = enabledCellsDecoration;
        TextStyle style = enabledCellsTextStyle;

        if (isCurrent) {
          //
          //
          style = currentDateTextStyle;
          decoration = currentDateDecoration;
        }

        if (isSingleCellSelected || isStartDate || isEndDate) {
          //
          //
          style = singelSelectedCellTextStyle;
          decoration = singelSelectedCellDecoration;
        }
        if (isWithinRange) {
          //
          //
          style = selectedCellsTextStyle;
          decoration = selectedCellsDecoration;
        }

        if (isDisabled) {
          //
          //
          style = disbaledCellsTextStyle;
          decoration = disbaledCellsDecoration;
        }

        if (isCurrent && isDisabled) {
          //
          //
          style = disbaledCellsTextStyle;
          decoration = currentDateDecoration;
        }

        Widget dayWidget = Center(
          child: Text(
            localizations.formatDecimal(day),
            style: style,
          ),
        );

        dayWidget = Container(
          clipBehavior: Clip.hardEdge,
          decoration: decoration,
          child: dayWidget,
        );

        if ((isStartDate || isEndDate) && isRangeSelected) {
          dayWidget = CustomPaint(
            painter: _DecorationPainter(
              textDirection: Directionality.of(context),
              color: selectedCellsDecoration.color!,
              start: isStartDate,
            ),
            child: dayWidget,
          );
        }

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () {
              final isStart =
                  (selectedEndDate == null && selectedStartDate == null) ||
                      (selectedEndDate != null && selectedStartDate != null);

              if (isStart) {
                onStartDateChanged(dayToBuild);
                return;
              }

              if (dayToBuild.isBefore(selectedStartDate!)) {
                onStartDateChanged(dayToBuild);
                onEndDateChanged(selectedStartDate!);
                return;
              }

              if (dayToBuild == selectedStartDate) {
                return;
              }

              onEndDateChanged(dayToBuild);
            },
            radius: splashRadius ?? _dayPickerRowHeight / 2 + 4,
            splashColor: splashColor,
            highlightColor: highlightColor,
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const PickerGridDelegate(
        columnCount: DateTime.daysPerWeek,
        columnPadding: 0,
        rowPadding: 3,
        rowExtent: _dayPickerRowHeight,
        rowStride: _dayPickerRowHeight,
      ),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}

/// A custom painter class for decorating a widget with a colored rectangle.
///
/// The [_DecorationPainter] class extends [CustomPainter] and is responsible
/// for painting a colored rectangle on a canvas based on specified parameters.
/// This class is typically used as the painter for a [CustomPaint] widget to
/// achieve a customized visual effect.
///
/// ### Example:
///
/// ```dart
/// CustomPaint(
///   painter: _DecorationPainter(
///     textDirection: TextDirection.ltr,
///     color: Colors.blue,
///     start: true,
///   ),
///   child: // Your child widget goes here,
/// )
/// ```
class _DecorationPainter extends CustomPainter {
  /// Creates a [_DecorationPainter] with the specified parameters.
  ///
  /// The `textDirection` parameter is required to determine the positioning
  /// of the colored rectangle based on the text direction.
  ///
  /// The `color` parameter defines the color of the rectangle to be painted.
  ///
  /// The `start` parameter is a boolean value indicating whether the rectangle
  /// should be drawn at the start (left for LTR, right for RTL) or at the zero
  /// position of the canvas.
  _DecorationPainter({
    required this.textDirection,
    required this.color,
    required this.start,
  });

  /// The text direction to determine the positioning of the
  ///   colored rectangle. The rectangle will be drawn on either the left or
  ///   right side based on the text direction.
  final TextDirection textDirection;

  /// The color of the rectangle to be painted on the canvas.
  final Color color;

  /// A boolean value indicating whether the rectangle should be drawn
  ///   at the start (left for LTR, right for RTL) or at the zero position of
  ///   the canvas.
  final bool start;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width / 2;
    final height = size.height;

    final painter = Paint()..color = color;

    late final Offset offset;
    switch (textDirection) {
      case TextDirection.ltr:
        if (start) {
          offset = Offset(width, 0);
        } else {
          offset = Offset.zero;
        }
        break;
      case TextDirection.rtl:
        if (start) {
          offset = Offset.zero;
        } else {
          offset = Offset(width, 0);
        }
        break;
    }

    canvas.drawRect(offset & Size(width, height), painter);
  }

  @override
  bool shouldRepaint(covariant _DecorationPainter oldDelegate) {
    return oldDelegate.textDirection != textDirection ||
        oldDelegate.color != color ||
        oldDelegate.start != start;
  }
}
