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
}
