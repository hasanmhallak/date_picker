/// Describes the visual of a calendar cell.
///
/// This enum is provided to the cell builder to control how a cell
/// should be rendered. It represents **UI state only** and does not
/// handle interaction logic.
///
/// State precedence rules:
/// - If a cell is both *current* and *selected* (or *selectedEdge*), the state will be
///   [selected] (or [selectedEdge]). The builder will not receive [current] in this case.
/// - If a cell is both *current* and *disabled*, the state will be
///   [currentAndDisabled].
enum CellState {
  /// The cell is not interactive.
  ///
  /// Typically used for:
  /// - Values outside the allowed range
  /// - Non-selectable days, months, or years
  ///
  /// The cell should appear visually inactive.
  disabled,

  /// The cell is active and selectable.
  ///
  /// This is the default state for valid, interactive cells.
  enabled,

  /// The cell represents a selected value.
  ///
  /// This state has higher priority than [current]. If the current
  /// day/month/year is selected, the state will be [selected],
  /// not [current].
  selected,

  /// The cell is a selected edge of a range.
  ///
  /// Used when:
  /// - The cell is the start of a selected range.
  /// - The cell is the end of a selected range.
  /// - Only one cell is selected (range not yet completed).
  ///
  /// This is only relevant for range pickers. Non-range pickers
  /// should treat this the same as [selected].
  selectedEdge,

  /// The cell represents the current reference value.
  ///
  /// Examples:
  /// - Today in day view
  /// - Current month in month view
  /// - Current year in year view
  ///
  /// This state is only provided when the cell is not selected.
  current,

  /// The cell represents the current reference value but is not selectable.
  ///
  /// Example:
  /// - Today exists but falls outside the allowed range.
  ///
  /// This allows the builder to visually indicate the current value
  /// while keeping the cell disabled.
  currentAndDisabled,
}
