import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/cell_state.dart';
import 'ink_response_theme.dart';

/// A theme that controls the visual appearance of the grid of months.
@immutable
class MonthsPickerTheme extends ThemeExtension<MonthsPickerTheme>
    with DiagnosticableTreeMixin {
  /// Creates a [MonthsPickerTheme].
  const MonthsPickerTheme({
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration,
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration,
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellTextStyle,
    this.selectedCellDecoration,
    this.cellsPadding,
    this.padding,
    this.inkResponseTheme,
  });

  /// The text style of month cells which are selectable.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color.
  final TextStyle? enabledCellsTextStyle;

  /// The cell decoration of month cells which are selectable.
  ///
  /// Defaults to empty [BoxDecoration].
  final Decoration? enabledCellsDecoration;

  /// The text style of month cells which are not selectable.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onSurface] color with 30% opacity.
  final TextStyle? disabledCellsTextStyle;

  /// The cell decoration of month cells which are not selectable.
  ///
  /// Defaults to empty [BoxDecoration].
  final Decoration? disabledCellsDecoration;

  /// The text style of the current month.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.primary] color.
  final TextStyle? currentDateTextStyle;

  /// The cell decoration of the current month cell.
  ///
  /// Defaults to [BoxDecoration] with a stroke border with [ColorScheme.primary] color and [BorderRadius.circular(12)] border radius.
  final Decoration? currentDateDecoration;

  /// The text style of selected month cell.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedCellTextStyle;

  /// The cell decoration of selected month cell.
  ///
  /// Defaults to [BoxDecoration] with a [ColorScheme.primary] color and [BorderRadius.circular(12)] border radius.
  final Decoration? selectedCellDecoration;

  /// Padding around each month cell's content (inside the grid tile, around the
  /// decorated [Container]).
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 8, vertical: 16)`.
  final EdgeInsetsGeometry? cellsPadding;

  /// Padding around the months grid (the [PageView] below the header).
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? padding;

  /// The splash and highlight theme for the ink response when tapping cells.
  final InkResponseTheme? inkResponseTheme;

  /// Returns a [MonthsPickerTheme] populated with default values.
  static MonthsPickerTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return MonthsPickerTheme(
      enabledCellsTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      enabledCellsDecoration: const BoxDecoration(),
      disabledCellsTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      disabledCellsDecoration: const BoxDecoration(),
      currentDateTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.primary,
      ),
      currentDateDecoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      selectedCellTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      selectedCellDecoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      cellsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: EdgeInsets.zero,
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
  MonthsPickerTheme copyWith({
    TextStyle? enabledCellsTextStyle,
    Decoration? enabledCellsDecoration,
    TextStyle? disabledCellsTextStyle,
    Decoration? disabledCellsDecoration,
    TextStyle? currentDateTextStyle,
    Decoration? currentDateDecoration,
    TextStyle? selectedCellTextStyle,
    Decoration? selectedCellDecoration,
    EdgeInsetsGeometry? cellsPadding,
    EdgeInsetsGeometry? padding,
    InkResponseTheme? inkResponseTheme,
  }) {
    return MonthsPickerTheme(
      enabledCellsTextStyle:
          enabledCellsTextStyle ?? this.enabledCellsTextStyle,
      enabledCellsDecoration:
          enabledCellsDecoration ?? this.enabledCellsDecoration,
      disabledCellsTextStyle:
          disabledCellsTextStyle ?? this.disabledCellsTextStyle,
      disabledCellsDecoration:
          disabledCellsDecoration ?? this.disabledCellsDecoration,
      currentDateTextStyle: currentDateTextStyle ?? this.currentDateTextStyle,
      currentDateDecoration:
          currentDateDecoration ?? this.currentDateDecoration,
      selectedCellTextStyle:
          selectedCellTextStyle ?? this.selectedCellTextStyle,
      selectedCellDecoration:
          selectedCellDecoration ?? this.selectedCellDecoration,
      cellsPadding: cellsPadding ?? this.cellsPadding,
      padding: padding ?? this.padding,
      inkResponseTheme: inkResponseTheme ?? this.inkResponseTheme,
    );
  }

  /// Merges the properties of [other] into this theme.
  MonthsPickerTheme merge(covariant MonthsPickerTheme? other) {
    if (other == null) return this;
    return copyWith(
      enabledCellsTextStyle:
          enabledCellsTextStyle?.merge(other.enabledCellsTextStyle) ??
              other.enabledCellsTextStyle,
      enabledCellsDecoration: other.enabledCellsDecoration,
      disabledCellsTextStyle:
          disabledCellsTextStyle?.merge(other.disabledCellsTextStyle) ??
              other.disabledCellsTextStyle,
      disabledCellsDecoration: other.disabledCellsDecoration,
      currentDateTextStyle:
          currentDateTextStyle?.merge(other.currentDateTextStyle) ??
              other.currentDateTextStyle,
      currentDateDecoration: other.currentDateDecoration,
      selectedCellTextStyle:
          selectedCellTextStyle?.merge(other.selectedCellTextStyle) ??
              other.selectedCellTextStyle,
      selectedCellDecoration: other.selectedCellDecoration,
      cellsPadding: other.cellsPadding,
      padding: other.padding,
      inkResponseTheme: inkResponseTheme?.merge(other.inkResponseTheme) ??
          other.inkResponseTheme,
    );
  }

  @override
  MonthsPickerTheme lerp(
      covariant ThemeExtension<MonthsPickerTheme>? other, double t) {
    if (other is! MonthsPickerTheme) return this;

    return MonthsPickerTheme(
      enabledCellsTextStyle:
          TextStyle.lerp(enabledCellsTextStyle, other.enabledCellsTextStyle, t),
      enabledCellsDecoration: Decoration.lerp(
          enabledCellsDecoration, other.enabledCellsDecoration, t),
      disabledCellsTextStyle: TextStyle.lerp(
          disabledCellsTextStyle, other.disabledCellsTextStyle, t),
      disabledCellsDecoration: Decoration.lerp(
          disabledCellsDecoration, other.disabledCellsDecoration, t),
      currentDateTextStyle:
          TextStyle.lerp(currentDateTextStyle, other.currentDateTextStyle, t),
      currentDateDecoration: Decoration.lerp(
          currentDateDecoration, other.currentDateDecoration, t),
      selectedCellTextStyle:
          TextStyle.lerp(selectedCellTextStyle, other.selectedCellTextStyle, t),
      selectedCellDecoration: Decoration.lerp(
          selectedCellDecoration, other.selectedCellDecoration, t),
      cellsPadding:
          EdgeInsetsGeometry.lerp(cellsPadding, other.cellsPadding, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      inkResponseTheme: inkResponseTheme?.lerp(other.inkResponseTheme, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle?>(
        'enabledCellsTextStyle', enabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>(
        'enabledCellsDecoration', enabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'disabledCellsTextStyle', disabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>(
        'disabledCellsDecoration', disabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'currentDateTextStyle', currentDateTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>(
        'currentDateDecoration', currentDateDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>(
        'selectedCellTextStyle', selectedCellTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>(
        'selectedCellDecoration', selectedCellDecoration));
    properties.add(
        DiagnosticsProperty<EdgeInsetsGeometry?>('cellsPadding', cellsPadding));
    properties
        .add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<InkResponseTheme?>(
        'inkResponseTheme', inkResponseTheme));
  }
}
