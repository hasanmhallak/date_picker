import 'package:flutter/widgets.dart';

import 'cell_data.dart';

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

/// Signature for building a custom calendar cell widget.
///
/// The [context] is the build context of the cell, and [data] carries
/// the cell's semantic type ([DayCell], [MonthCell], etc.), its visual
/// [CellState], and the bare default widget ([CellData.child]).
///
/// [data.child] is the decorated container (padding, background, text)
/// **without** any [InkResponse] or [Semantics]. The picker wraps the
/// widget returned by this builder with its own [ExcludeSemantics],
/// [Semantics], and [InkResponse] layers. Any [Semantics] nodes added
/// inside the builder will therefore be excluded from the accessibility
/// tree.
///
/// Return the widget that should be placed in the grid slot.
/// To keep the default appearance and add an overlay, wrap [data.child]
/// in a [Stack]:
///
/// ```dart
/// cellBuilder: (context, data) {
///   return Stack(
///     children: [
///       data.child,
///       Positioned(top: 2, right: 2, child: badge),
///     ],
///   );
/// }
/// ```
typedef CellBuilder = Widget Function(BuildContext context, CellData data);
