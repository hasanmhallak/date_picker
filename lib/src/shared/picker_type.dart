import 'package:date_picker_plus/date_picker_plus.dart';

/// Initial display of the picker.
///
/// See also:
///
///  * [showRangePickerDialog], which shows a dialog that
///     contains a range picker.
///
///  * [RangeDatePicker], widget which implements a Range picker.
///
///  * [showDatePickerDialog], which shows a dialog that
///     contains a date picker.
///
///  * [DatePicker], widget which implements a date picker.
///
enum PickerType {
  /// Choosing a day.
  days,

  /// Choosing a month.
  months,

  /// Choosing a year.
  years,
}
