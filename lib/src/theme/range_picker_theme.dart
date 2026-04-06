import '../range/range_selection_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/cell_state.dart';
import 'ink_response_theme.dart';

/// A theme that controls the visual appearance of the grid of days in a range picker.
@immutable
class RangePickerTheme extends ThemeExtension<RangePickerTheme> with DiagnosticableTreeMixin {
  /// Creates a [RangePickerTheme].
  const RangePickerTheme({
    this.enabledCellsTextStyle,
    this.enabledCellsDecoration,
    this.disabledCellsTextStyle,
    this.disabledCellsDecoration,
    this.currentDateTextStyle,
    this.currentDateDecoration,
    this.selectedCellsTextStyle,
    this.selectedCellsDecoration,
    this.selectedEdgeCellTextStyle,
    this.selectedEdgeCellDecoration,
    this.cellsPadding,
    this.padding,
    this.inkResponseTheme,
    this.resolvePainter,
  });

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

  /// The text style for cells inside a selected range.
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimaryContainer] color.
  final TextStyle? selectedCellsTextStyle;

  /// The decoration for cells inside a selected range.
  ///
  /// Defaults to rectangle with [ColorScheme.primaryContainer] color.
  ///
  /// Note: If you provide a custom [Decoration] that is not a [BoxDecoration]
  /// or [ShapeDecoration], you must also provide a custom [resolvePainter]
  /// to correctly handle painting the range highlight color.
  final Decoration? selectedCellsDecoration;

  /// The text style for a selected edge cell (start/end of range or single selection).
  ///
  /// Defaults to [TextTheme.titleLarge] with a [FontWeight.normal]
  /// and [ColorScheme.onPrimary] color.
  final TextStyle? selectedEdgeCellTextStyle;

  /// The decoration for a selected edge cell (start/end of range or single selection).
  ///
  /// Defaults to circle with [ColorScheme.primary] color.
  ///
  /// **Note:** When the picker's grid cells are taller than they are wide
  /// (non-square aspect ratio), the default [CircleBorder] decoration will be
  /// inscribed in the cell's shorter dimension (width), leaving vertical space
  /// that the [RangeSelectionPainter] still fills with a full-height rectangle.
  /// This creates a visible gap between the range highlight and the edge circle.
  ///
  /// To fix this, use a shape that stretches to fill the cell, such as:
  ///
  /// ```dart
  /// selectedEdgeCellDecoration: ShapeDecoration(
  ///   color: colorScheme.primary,
  ///   shape: const OvalBorder(),   // or StadiumBorder()
  /// ),
  /// ```
  ///
  /// Alternatively, provide a custom [resolvePainter] that adjusts the
  /// painted rectangle to match the decoration height.
  final Decoration? selectedEdgeCellDecoration;

  /// Padding around each day cell's content (inside the grid tile, around the
  /// decorated [Container]).
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? cellsPadding;

  /// Padding around the range days grid (the [PageView] below the header).
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? padding;

  /// The splash and highlight theme for the ink response when tapping cells.
  ///
  /// Defaults to the splash color of [selectedCellsDecoration] with 30% opacity,
  /// if [selectedCellsDecoration] is null will fall back to
  /// [ColorScheme.onPrimary] with 30% opacity.
  final InkResponseTheme? inkResponseTheme;

  /// A custom painter to draw background decorations behind the dates (e.g. range highlights).
  ///
  /// If [selectedCellsDecoration] uses a [Decoration] implementation other than
  /// [BoxDecoration] or [ShapeDecoration], you must provide a custom [ResolvePainter]
  /// to correctly resolve and paint the background color.
  final ResolvePainter? resolvePainter;

  /// Returns a [RangePickerTheme] populated with default values.
  static RangePickerTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final titleLarge = textTheme.titleLarge;

    return RangePickerTheme(
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
      selectedCellsTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimaryContainer,
      ),
      selectedCellsDecoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.rectangle,
      ),
      selectedEdgeCellTextStyle: titleLarge?.copyWith(
        fontWeight: FontWeight.normal,
        color: colorScheme.onPrimary,
      ),
      selectedEdgeCellDecoration: BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      ),
      cellsPadding: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      inkResponseTheme: InkResponseTheme.defaults(context),
      resolvePainter: (textDirection, color, start) {
        return RangeSelectionPainter(
          textDirection: textDirection,
          color: color,
          start: start,
        );
      },
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
        return selectedCellsTextStyle;
      case CellState.selectedEdge:
        return selectedEdgeCellTextStyle;
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
        return selectedCellsDecoration;
      case CellState.selectedEdge:
        return selectedEdgeCellDecoration;
      case CellState.enabled:
        return enabledCellsDecoration;
    }
  }

  @override
  RangePickerTheme copyWith({
    TextStyle? enabledCellsTextStyle,
    Decoration? enabledCellsDecoration,
    TextStyle? disabledCellsTextStyle,
    Decoration? disabledCellsDecoration,
    TextStyle? currentDateTextStyle,
    Decoration? currentDateDecoration,
    TextStyle? selectedCellsTextStyle,
    Decoration? selectedCellsDecoration,
    TextStyle? selectedEdgeCellTextStyle,
    Decoration? selectedEdgeCellDecoration,
    EdgeInsetsGeometry? cellsPadding,
    EdgeInsetsGeometry? padding,
    InkResponseTheme? inkResponseTheme,
    ResolvePainter? resolvePainter,
  }) {
    return RangePickerTheme(
      enabledCellsTextStyle: enabledCellsTextStyle ?? this.enabledCellsTextStyle,
      enabledCellsDecoration: enabledCellsDecoration ?? this.enabledCellsDecoration,
      disabledCellsTextStyle: disabledCellsTextStyle ?? this.disabledCellsTextStyle,
      disabledCellsDecoration: disabledCellsDecoration ?? this.disabledCellsDecoration,
      currentDateTextStyle: currentDateTextStyle ?? this.currentDateTextStyle,
      currentDateDecoration: currentDateDecoration ?? this.currentDateDecoration,
      selectedCellsTextStyle: selectedCellsTextStyle ?? this.selectedCellsTextStyle,
      selectedCellsDecoration: selectedCellsDecoration ?? this.selectedCellsDecoration,
      selectedEdgeCellTextStyle: selectedEdgeCellTextStyle ?? this.selectedEdgeCellTextStyle,
      selectedEdgeCellDecoration: selectedEdgeCellDecoration ?? this.selectedEdgeCellDecoration,
      cellsPadding: cellsPadding ?? this.cellsPadding,
      padding: padding ?? this.padding,
      inkResponseTheme: inkResponseTheme ?? this.inkResponseTheme,
      resolvePainter: resolvePainter ?? this.resolvePainter,
    );
  }

  /// Merges the properties of [other] into this theme.
  RangePickerTheme merge(covariant RangePickerTheme? other) {
    if (other == null) return this;
    return copyWith(
      enabledCellsTextStyle: enabledCellsTextStyle?.merge(other.enabledCellsTextStyle) ?? other.enabledCellsTextStyle,
      enabledCellsDecoration: other.enabledCellsDecoration,
      disabledCellsTextStyle:
          disabledCellsTextStyle?.merge(other.disabledCellsTextStyle) ?? other.disabledCellsTextStyle,
      disabledCellsDecoration: other.disabledCellsDecoration,
      currentDateTextStyle: currentDateTextStyle?.merge(other.currentDateTextStyle) ?? other.currentDateTextStyle,
      currentDateDecoration: other.currentDateDecoration,
      selectedCellsTextStyle:
          selectedCellsTextStyle?.merge(other.selectedCellsTextStyle) ?? other.selectedCellsTextStyle,
      selectedCellsDecoration: other.selectedCellsDecoration,
      selectedEdgeCellTextStyle:
          selectedEdgeCellTextStyle?.merge(other.selectedEdgeCellTextStyle) ?? other.selectedEdgeCellTextStyle,
      selectedEdgeCellDecoration: other.selectedEdgeCellDecoration,
      cellsPadding: other.cellsPadding,
      padding: other.padding,
      inkResponseTheme: inkResponseTheme?.merge(other.inkResponseTheme) ?? other.inkResponseTheme,
      resolvePainter: other.resolvePainter,
    );
  }

  @override
  RangePickerTheme lerp(covariant ThemeExtension<RangePickerTheme>? other, double t) {
    if (other is! RangePickerTheme) return this;

    return RangePickerTheme(
      enabledCellsTextStyle: TextStyle.lerp(enabledCellsTextStyle, other.enabledCellsTextStyle, t),
      enabledCellsDecoration: Decoration.lerp(enabledCellsDecoration, other.enabledCellsDecoration, t),
      disabledCellsTextStyle: TextStyle.lerp(disabledCellsTextStyle, other.disabledCellsTextStyle, t),
      disabledCellsDecoration: Decoration.lerp(disabledCellsDecoration, other.disabledCellsDecoration, t),
      currentDateTextStyle: TextStyle.lerp(currentDateTextStyle, other.currentDateTextStyle, t),
      currentDateDecoration: Decoration.lerp(currentDateDecoration, other.currentDateDecoration, t),
      selectedCellsTextStyle: TextStyle.lerp(selectedCellsTextStyle, other.selectedCellsTextStyle, t),
      selectedCellsDecoration: Decoration.lerp(selectedCellsDecoration, other.selectedCellsDecoration, t),
      selectedEdgeCellTextStyle: TextStyle.lerp(selectedEdgeCellTextStyle, other.selectedEdgeCellTextStyle, t),
      selectedEdgeCellDecoration: Decoration.lerp(selectedEdgeCellDecoration, other.selectedEdgeCellDecoration, t),
      cellsPadding: EdgeInsetsGeometry.lerp(cellsPadding, other.cellsPadding, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      inkResponseTheme: inkResponseTheme?.lerp(other.inkResponseTheme, t),
      resolvePainter: t < 0.5 ? resolvePainter : other.resolvePainter,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle?>('enabledCellsTextStyle', enabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('enabledCellsDecoration', enabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('disabledCellsTextStyle', disabledCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('disabledCellsDecoration', disabledCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('currentDateTextStyle', currentDateTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('currentDateDecoration', currentDateDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('selectedCellsTextStyle', selectedCellsTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('selectedCellsDecoration', selectedCellsDecoration));
    properties.add(DiagnosticsProperty<TextStyle?>('selectedEdgeCellTextStyle', selectedEdgeCellTextStyle));
    properties.add(DiagnosticsProperty<Decoration?>('selectedEdgeCellDecoration', selectedEdgeCellDecoration));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('cellsPadding', cellsPadding));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<InkResponseTheme?>('inkResponseTheme', inkResponseTheme));
    properties.add(DiagnosticsProperty<ResolvePainter?>('resolvePainter', resolvePainter));
  }
}
