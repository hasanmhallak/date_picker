import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// ISO 8601 weekday (1 = Monday, 7 = Sunday) for [locale].
///
/// Uses ICU `FIRSTDAYOFWEEK` where 0 means Monday.
int isoStartOfWeek(Locale locale) {
  final firstDay = DateFormat('', locale.toString()).dateSymbols.FIRSTDAYOFWEEK;
  return firstDay + 1;
}

String formatMonthYear(Locale locale, DateTime date) {
  return DateFormat.yMMMM(locale.toString()).format(date);
}

/// Month-year for the picker header, with Eastern Arabic digits mapped to ASCII.
String formatMonthYearHeader(Locale locale, DateTime date) {
  return toAsciiDigits(formatMonthYear(locale, date));
}

String formatFullDate(Locale locale, DateTime date) {
  return DateFormat.yMMMMEEEEd(locale.toString()).format(date);
}

String toAsciiDigits(String input) {
  return input
      .replaceAll('٩', '9')
      .replaceAll('٨', '8')
      .replaceAll('٧', '7')
      .replaceAll('٦', '6')
      .replaceAll('٥', '5')
      .replaceAll('٤', '4')
      .replaceAll('٣', '3')
      .replaceAll('٢', '2')
      .replaceAll('١', '1')
      .replaceAll('٠', '0');
}
