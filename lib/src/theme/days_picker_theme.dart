import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/cell_state.dart';
import 'days_of_the_week_theme.dart';
import 'ink_response_theme.dart';

/// A theme that controls the visual appearance of the grid of days.
@immutable
class DaysPickerTheme extends ThemeExtension<DaysPickerTheme> with DiagnosticableTreeMixin {
  /// Creates a [DaysPickerTheme].
  const DaysPickerTheme({
    this.daysOfTheWeekTheme,
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration,
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration,
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.cellsPadding,
    this.inkResponseTheme,
  });

  /// The theme controlling the "Monday, Tuesday..." abbreviated row.
  final DaysOfTheWeekTheme? daysOfTheWeekTheme;

  /// The text style of cells which are selectable.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of cells which are selectable.
  ///
  /// Defaults to empty [BoxDecoration].
  final Decoration? enabledCellsDecoration;

  /// The text style of cells which are not selectable.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of cells which are not selectable.
  ///
  /// Defaults to empty [BoxDecoration].
  final Decoration? disabledCellsDecoration;

  /// The text style of the current date.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current date.
  ///
  /// Defaults to circle stroke border with [ColorScheme.primary] color.
  final Decoration? currentDateDecoration;

  /// The text style of selected cell.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected cell.
  ///
  /// Defaults to circle with [ColorScheme.primary] color.
  final Decoration? selectedCellDecoration;

  /// Padding around each day cell's content (inside the grid tile, around the
  /// decorated [Container]).
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? cellsPadding;

  /// The splash and highlight theme for the ink response when tapping cells.
  ///
  /// Defaults to the splash color of [selectedCellDecoration] with 30% opacity,
  /// if [selectedCellDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final InkResponseTheme? inkResponseTheme;

  /// Returns a [DaysPickerTheme] populated with default values.
  static DaysPickerTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;

    return DaysPickerTheme(
      daysOfTheWeekTheme: DaysOfTheWeekTheme.defaults(context),
      enabledCellsTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      enabledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      disabledCellsDecoration: const BoxDecoration(),
      currentDateTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.primary,
      ),
      currentDateDecoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        shape: BoxShape.circle,
      ),
      selectedCellTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      selectedCellDecoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      cellsPadding: EdgeInsets.zero,
      inkResponseTheme: InkResponseTheme.defaults(context),
    );
  }

  /// Resolves the text style based on the provided [state].
  TextStyle? resolveTextStyle(CellState state) {
    switch (state) {
      case CellState.disabled:
        return disabledCellsTextStyle;
      case CellState.currentAndDisabled:
        return disabledCellsTextStyle;
      case CellState.current:
        return currentDateTextStyle;
      case CellState.selected:
      case CellState.selectedEdge:
        return selectedCellTextStyle;
      case CellState.enabled:
        return enabledCellsTextStyle;
    }
  }

  /// Resolves the decoration based on the provided [state].
  Decoration? resolveDecoration(CellState state) {
    switch (state) {
      case CellState.disabled:
        return disabledCellsDecoration;
      case CellState.currentAndDisabled:
        return currentDateDecoration;
      case CellState.current:
        return currentDateDecoration;
      case CellState.selected:
      case CellState.selectedEdge:
        return selectedCellDecoration;
      case CellState.enabled:
        return enabledCellsDecoration;
    }
  }

  @override
  DaysPickerTheme copyWith({
    DaysOfTheWeekTheme? daysOfTheWeekTheme,
    TextStyle? enabledCellsTextStyle,
    Decoration? enabledCellsDecoration,
    TextStyle? disabledCellsTextStyle,
    Decoration? disabledCellsDecoration,
    TextStyle? currentDateTextStyle,
    Decoration? currentDateDecoration,
    TextStyle? selectedCellTextStyle,
    Decoration? selectedCellDecoration,
    EdgeInsetsGeometry? cellsPadding,
    InkResponseTheme? inkResponseTheme,
  }) {
    return DaysPickerTheme(
      daysOfTheWeekTheme: daysOfTheWeekTheme ?? this.daysOfTheWeekTheme,
      enabledCellsTextStyle: enabledCellsTextStyle ?? this.enabledCellsTextStyle,
      enabledCellsDecoration: enabledCellsDecoration ?? this.enabledCellsDecoration,
      disabledCellsTextStyle: disabledCellsTextStyle ?? this.disabledCellsTextStyle,
      disabledCellsDecoration: disabledCellsDecoration ?? this.disabledCellsDecoration,
      currentDateTextStyle: currentDateTextStyle ?? this.currentDateTextStyle,
      currentDateDecoration: currentDateDecoration ?? this.currentDateDecoration,
      selectedCellTextStyle: selectedCellTextStyle ?? this.selectedCellTextStyle,
      selectedCellDecoration: selectedCellDecoration ?? this.selectedCellDecoration,
      cellsPadding: cellsPadding ?? this.cellsPadding,
      inkResponseTheme: inkResponseTheme ?? this.inkResponseTheme,
    );
  }

  /// Merges the properties of [other] into this theme.
  DaysPickerTheme merge(covariant DaysPickerTheme? other) {
    if (other == null) return this;
    return copyWith(
      daysOfTheWeekTheme: daysOfTheWeekTheme?.merge(other.daysOfTheWeekTheme) ?? other.daysOfTheWeekTheme,
      enabledCellsTextStyle: other.enabledCellsTextStyle,
      enabledCellsDecoration: other.enabledCellsDecoration,
      disabledCellsTextStyle: other.disabledCellsTextStyle,
      disabledCellsDecoration: other.disabledCellsDecoration,
      currentDateTextStyle: other.currentDateTextStyle,
      currentDateDecoration: other.currentDateDecoration,
      selectedCellTextStyle: other.selectedCellTextStyle,
      selectedCellDecoration: other.selectedCellDecoration,
      cellsPadding: other.cellsPadding,
      inkResponseTheme: inkResponseTheme?.merge(other.inkResponseTheme) ?? other.inkResponseTheme,
    );
  }

  @override
  DaysPickerTheme lerp(covariant ThemeExtension<DaysPickerTheme>? other, double t) {
    if (other is! DaysPickerTheme) return this;

    return DaysPickerTheme(
      daysOfTheWeekTheme: daysOfTheWeekTheme?.lerp(other.daysOfTheWeekTheme, t),
      enabledCellsTextStyle: TextStyle.lerp(enabledCellsTextStyle, other.enabledCellsTextStyle, t),
      enabledCellsDecoration: Decoration.lerp(enabledCellsDecoration, other.enabledCellsDecoration, t),
      disabledCellsTextStyle: TextStyle.lerp(disabledCellsTextStyle, other.disabledCellsTextStyle, t),
      disabledCellsDecoration: Decoration.lerp(disabledCellsDecoration, other.disabledCellsDecoration, t),
      currentDateTextStyle: TextStyle.lerp(currentDateTextStyle, other.currentDateTextStyle, t),
      currentDateDecoration: Decoration.lerp(currentDateDecoration, other.currentDateDecoration, t),
      selectedCellTextStyle: TextStyle.lerp(selectedCellTextStyle, other.selectedCellTextStyle, t),
      selectedCellDecoration: Decoration.lerp(selectedCellDecoration, other.selectedCellDecoration, t),
      cellsPadding: EdgeInsetsGeometry.lerp(cellsPadding, other.cellsPadding, t),
      inkResponseTheme: inkResponseTheme?.lerp(other.inkResponseTheme, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DaysOfTheWeekTheme?>('daysOfTheWeekTheme', daysOfTheWeekTheme));
    properties.add(DiagnosticsProperty<TextStyle?>('enabledCellsTextStyle', enabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('enabledCellsDecoration', enabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('disabledCellsTextStyle', disabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('disabledCellsDecoration', disabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('currentDateTextStyle', currentDateTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('currentDateDecoration', currentDateDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('selectedCellTextStyle', selectedCellTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('selectedCellDecoration', selectedCellDecoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('cellsPadding', cellsPadding));
    properties.add(DiagnosticsProperty<InkResponseTheme?>('inkResponseTheme', inkResponseTheme));
  }
}
