import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../theme/days_of_the_week_theme.dart';

/// Builds a list of widgets representing the days of the week.
///
/// The order of the widgets is determined by the [theme.startOfWeek] property,
/// which follows ISO 8601 (1 = Monday, 7 = Sunday). The text displayed for
/// each day is localized according to the provided [locale] and formatted
/// based on the [theme.weekdayLength]. Each header is styled using
/// [theme.decoration]. These widgets are not selectable and are excluded from
/// semantics.
List<Widget> dayHeaders(DaysOfTheWeekTheme theme, Locale locale) {
  final List<Widget> result = <Widget>[];

  // Retrieve the localized weekday names from date symbols based on the
  // requested length (long, short, or narrow).
  final dateSymbols = DateFormat('', locale.toString()).dateSymbols;
  final weekdayNames = switch (theme.weekdayLength!) {
    WeekdayLength.long => dateSymbols.WEEKDAYS,
    WeekdayLength.short => dateSymbols.SHORTWEEKDAYS,
    WeekdayLength.narrow => dateSymbols.NARROWWEEKDAYS,
  };

  // Convert ISO 8601 weekday (1-7) to DateSymbols index (0-6, where 0 is Sunday).
  // Defaults to Monday (1) if no start day is provided in the theme.
  final int startOfWeek = theme.startOfWeek!;
  final int firstDayOfWeekIndex = startOfWeek == 7 ? 0 : startOfWeek;

  // Iterate through exactly 7 days, starting from the configured first day.
  for (int i = firstDayOfWeekIndex; true; i = (i + 1) % 7) {
    final String weekday = weekdayNames[i];
    result.add(
      ExcludeSemantics(
        child: Container(
          decoration: theme.decoration,
          child: Center(
            child: Text(
              weekday.toUpperCase(),
              style: theme.textStyle,
            ),
          ),
        ),
      ),
    );

    // Stop the loop once we have returned to the day preceding the start day.
    if (i == (firstDayOfWeekIndex - 1 + 7) % 7) {
      break;
    }
  }
  return result;
}
