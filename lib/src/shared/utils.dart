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
}
