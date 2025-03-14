/// Signature for evaluating a date.
///
/// A [DatePredicate] is a function that takes a [DateTime] object as input and
/// returns a boolean value. This can be used for filtering or validating dates
/// based on specific criteria.
///
/// Example usage:
/// ```dart
/// bool isWeekend(DateTime date) {
///   return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
/// }
///
/// DatePredicate isWeekendPredicate = isWeekend;
/// ```
typedef DatePredicate = bool Function(DateTime date);
