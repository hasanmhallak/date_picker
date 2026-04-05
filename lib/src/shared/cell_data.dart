import 'package:flutter/widgets.dart';

import 'cell_state.dart';

/// Describes a calendar cell with its semantic data, visual state,
/// and the default widget the picker would render.
///
/// This sealed class is provided to the [CellBuilder] callback so
/// consumers can inspect, wrap, or replace the default cell widget.
///
/// Each subclass carries the data specific to the cell kind
/// (weekday label, day, month, or year).
sealed class CellData {
  /// Base constructor.
  const CellData({required this.state, required this.child});

  /// The visual state of this cell (enabled, disabled, selected, etc.).
  final CellState state;

  /// The bare visual widget for this cell.
  ///
  /// This is the decorated container (padding, background, text) **without**
  /// any [InkResponse], [Semantics], or [ExcludeSemantics] wrapping.
  /// The picker applies its own interaction and accessibility layers
  /// after the [CellBuilder] returns.
  final Widget child;
}

/// Describes a header cell representing a day of the week.
///
/// Used by the builder to render labels such as Mon, Tue, etc.
class WeekDayCell extends CellData {
  /// ISO 8601 weekday number:
  /// - 1 = Monday
  /// - 7 = Sunday
  final int weekDay;

  /// Creates a weekday descriptor for the given [weekDay].
  const WeekDayCell({required this.weekDay, required super.state, required super.child})
      : assert(weekDay >= 1 && weekDay <= 7);
}

/// Describes a cell representing a specific calendar date.
///
/// Used by the builder to render a day cell inside a days view.
class DayCell extends CellData {
  /// The date associated with this cell.
  ///
  /// Only the date components are relevant. Time values
  /// should be ignored by consumers.
  final DateTime day;

  /// Creates a day descriptor for the given [day].
  const DayCell({required this.day, required super.state, required super.child});
}

/// Describes a cell representing a specific month within a year.
///
/// Used by the builder to render a month cell inside a months view.
class MonthCell extends CellData {
  /// Month number in the range 1..12.
  final int month;

  /// The year this month belongs to.
  final int year;

  /// Creates a month descriptor.
  ///
  /// Example: MonthCell(month: 2, year: 2026) -> February 2026.
  const MonthCell({required this.month, required this.year, required super.state, required super.child})
      : assert(month >= 1 && month <= 12);
}

/// Describes a cell representing a single year.
///
/// Used by the builder to render a year cell inside a years view.
class YearCell extends CellData {
  /// The year represented by this cell.
  final int year;

  /// Creates a year descriptor.
  const YearCell({required this.year, required super.state, required super.child});
}
