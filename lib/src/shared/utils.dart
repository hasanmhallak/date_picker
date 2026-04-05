import 'package:flutter/material.dart';

extension DateUtilsX on DateUtils {
  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight and day set to 1.
  static DateTime monthOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }

  /// Returns a [DateTime] with the date of the original, but time set to
  /// midnight and day & month set to 1.
  static DateTime yearOnly(DateTime date) {
    return DateTime(date.year);
  }

  /// Clamps a [date] to fall within the provided [min] and [max] range.
  ///
  /// If [date] is before [min], this method returns [min]. If [date] is after [max],
  /// it returns [max]. Otherwise, it returns the [date] unchanged.
  ///
  /// This is useful for ensuring a DateTime value stays within a specific range.
  ///
  /// Returns the clamped [DateTime].
  static DateTime clampDateToRange({
    required DateTime min,
    required DateTime max,
    required DateTime date,
  }) {
    if (date.isBefore(min)) return min;
    if (date.isAfter(max)) return max;
    return date;
  }

  /// Computes the offset from the first day of the week that the first day of the [month] falls on.
  ///
  /// [startOfWeek] is an ISO 8601 weekday number (1 = Monday, 7 = Sunday).
  static int firstDayOffset(int year, int month, int startOfWeek) {
    // startOfWeek is ISO 8601: 1 = Monday, 7 = Sunday.
    // Convert to DateTime.weekday-compatible index (Monday = 0).
    final int firstDayOfWeekIndexMondayBased = (startOfWeek - 1) % 7;
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;
    return (weekdayFromMonday - firstDayOfWeekIndexMondayBased + 7) % 7;
  }
}
