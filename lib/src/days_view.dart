import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

import 'picker_grid_delegate.dart';

const double _dayPickerRowHeight = 52.0;

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class DaysView extends StatelessWidget {
  DaysView({
    super.key,
    required this.currentDate,
    required this.onChanged,
    required this.minDate,
    required this.maxDate,
    required this.displayedMonth,
    this.selectedDate,
    this.daysNameColor,
    this.enabledDaysColor,
    this.disbaledDaysColor,
    this.todayColor,
    this.selectedDayColor,
    this.selectedDayFillColor,
  }) : assert(!minDate.isAfter(maxDate), "minDate can't be after maxDate");

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDate;

  /// The current date at the time the picker is displayed.
  /// In other words, the day to be considered as today.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

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

  /// The color of the days name.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? daysNameColor;

  /// The color of enabled days which are selectable.
  ///
  /// defaults to [ColorScheme.onSurface].
  final Color? enabledDaysColor;

  /// The color of disabled days which are not selectable.
  ///
  /// defaults to [ColorScheme.onSurface] with 30% opacity.
  final Color? disbaledDaysColor;

  /// The color of the current day.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? todayColor;

  /// The color of the selected day.
  ///
  /// defaults to [ColorScheme.onPrimary].
  final Color? selectedDayColor;

  /// The fill color of the selected day.
  ///
  /// defaults to [ColorScheme.primary].
  final Color? selectedDayFillColor;

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
    TextStyle? headerStyle,
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
      // final bool isToday = (i == todayIndex);
      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday.toUpperCase(),
              style: headerStyle,
              // style: isToday
              //     ? headerStyle?.copyWith(color: Colors.red)
              //     : headerStyle,
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    //
    //
    //
    final TextStyle? headerStyle = textTheme.titleSmall?.copyWith(
      color: daysNameColor ?? colorScheme.onSurface.withOpacity(0.30),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    //
    final Color enabledDayColor = enabledDaysColor ?? colorScheme.onSurface;
    final Color disabledDayColor =
        disbaledDaysColor ?? colorScheme.onSurface.withOpacity(0.30);
    final Color todayColor = this.todayColor ?? colorScheme.primary;
    //
    //
    final Color selectedDayColor =
        this.selectedDayColor ?? colorScheme.onPrimary;
    final Color selectedDayBackground =
        selectedDayFillColor ?? colorScheme.primary;
    //
    final TextStyle dayStyle = textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.normal,
    );

    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final List<Widget> dayItems = _dayHeaders(
      headerStyle,
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
        final bool isSelectedDay =
            DateUtils.isSameDay(selectedDate, dayToBuild);

        final bool isToday = DateUtils.isSameDay(currentDate, dayToBuild);
        //
        //
        BoxDecoration decoration = const BoxDecoration(shape: BoxShape.circle);
        Color dayColor = enabledDayColor;

        if (isSelectedDay) {
          // The selected day gets a circle background highlight, and a
          // contrasting text color.
          dayColor = selectedDayColor;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        } else if (isToday) {
          // The current day gets a different text color (if enabled) and a circle stroke
          // border.
          dayColor = todayColor;
          decoration = BoxDecoration(
            border: Border.all(color: dayColor),
            shape: BoxShape.circle,
          );
        }

        if (isDisabled) {
          dayColor = disabledDayColor;
        }

        Widget dayWidget = Container(
          decoration: decoration,
          child: Center(
            child: Text(
              localizations.formatDecimal(day),
              style: dayStyle.copyWith(color: dayColor),
            ),
          ),
        );

        if (isDisabled) {
          dayWidget = ExcludeSemantics(
            child: dayWidget,
          );
        } else {
          dayWidget = InkResponse(
            onTap: () => onChanged(dayToBuild),
            radius: _dayPickerRowHeight / 2.5 + 4,
            splashColor: selectedDayBackground.withOpacity(0.38),
            child: Semantics(
              // We want the day of month to be spoken first irrespective of the
              // locale-specific preferences or TextDirection. This is because
              // an accessibility user is more likely to be interested in the
              // day of month before the rest of the date, as they are looking
              // for the day of month. To do that we prepend day of month to the
              // formatted full date.
              label:
                  '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}',
              selected: isSelectedDay,
              excludeSemantics: true,
              child: dayWidget,
            ),
          );
        }

        dayItems.add(dayWidget);
      }
    }

    return GridView.custom(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const PickerGridDelegate(
        columnCount: DateTime.daysPerWeek,
        columnPadding: 4,
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
