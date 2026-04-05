import 'dart:ui' show lerpDouble;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A theme that encapsulates all properties related to InkWell and InkResponse.
///
/// This provides a convenient way to configure the splash and highlight behavior
/// for all interactive elements within the DatePicker.
@immutable
class InkResponseTheme extends ThemeExtension<InkResponseTheme> with DiagnosticableTreeMixin {
  /// Creates an [InkResponseTheme].
  const InkResponseTheme({
    this.radius,
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
    this.containedInkWell,
    this.customBorder,
    this.highlightShape,
    this.splashFactory,
    this.focusColor,
    this.hoverColor,
  });

  /// The radius of the ink splash.
  final double? radius;

  /// The splash color of the ink response.
  final Color? splashColor;

  /// The highlight color of the ink response.
  final Color? highlightColor;

  /// The clip border radius of the ink splash.
  final BorderRadius? borderRadius;

  /// Whether this ink response should be clipped to the bounding box.
  final bool? containedInkWell;

  /// The custom clip border which overrides [borderRadius].
  final ShapeBorder? customBorder;

  /// The shape (e.g., circular, rectangular) to use for the highlight.
  final BoxShape? highlightShape;

  /// Defines the appearance of the splash.
  final InteractiveInkFeatureFactory? splashFactory;

  /// The fill color of the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// The fill color of the button's [Material] when a pointer is hovering over it.
  final Color? hoverColor;

  /// Returns an [InkResponseTheme] populated with default values.
  static InkResponseTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    return InkResponseTheme(
      radius: null,
      splashColor: theme.splashColor,
      highlightColor: theme.highlightColor,
      borderRadius: null,
      containedInkWell: false,
      customBorder: null,
      highlightShape: BoxShape.circle,
      splashFactory: theme.splashFactory,
      focusColor: theme.focusColor,
      hoverColor: theme.hoverColor,
    );
  }

  @override
  InkResponseTheme copyWith({
    double? radius,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    bool? containedInkWell,
    ShapeBorder? customBorder,
    BoxShape? highlightShape,
    InteractiveInkFeatureFactory? splashFactory,
    Color? focusColor,
    Color? hoverColor,
  }) {
    return InkResponseTheme(
      radius: radius ?? this.radius,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      containedInkWell: containedInkWell ?? this.containedInkWell,
      customBorder: customBorder ?? this.customBorder,
      highlightShape: highlightShape ?? this.highlightShape,
      splashFactory: splashFactory ?? this.splashFactory,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
    );
  }

  /// Merges the properties of [other] into this theme.
  ///
  /// For any property that is null in [other], the value from this theme is used.
  InkResponseTheme merge(covariant InkResponseTheme? other) {
    if (other == null) return this;
    return copyWith(
      radius: other.radius,
      splashColor: other.splashColor,
      highlightColor: other.highlightColor,
      borderRadius: other.borderRadius,
      containedInkWell: other.containedInkWell,
      customBorder: other.customBorder,
      highlightShape: other.highlightShape,
      splashFactory: other.splashFactory,
      focusColor: other.focusColor,
      hoverColor: other.hoverColor,
    );
  }

  @override
  InkResponseTheme lerp(covariant ThemeExtension<InkResponseTheme>? other, double t) {
    if (other is! InkResponseTheme) {
      return this;
    }
    return InkResponseTheme(
      radius: lerpDouble(radius, other.radius, t),
      splashColor: Color.lerp(splashColor, other.splashColor, t),
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      containedInkWell: t < 0.5 ? containedInkWell : other.containedInkWell,
      customBorder: t < 0.5 ? customBorder : other.customBorder,
      highlightShape: t < 0.5 ? highlightShape : other.highlightShape,
      splashFactory: t < 0.5 ? splashFactory : other.splashFactory,
      focusColor: Color.lerp(focusColor, other.focusColor, t),
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('radius', radius));
    properties.add(ColorProperty('splashColor', splashColor));
    properties.add(ColorProperty('highlightColor', highlightColor));
    properties.add(DiagnosticsProperty<BorderRadius?>('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<bool?>('containedInkWell', containedInkWell));
    properties.add(DiagnosticsProperty<ShapeBorder?>('customBorder', customBorder));
    properties.add(DiagnosticsProperty<BoxShape?>('highlightShape', highlightShape));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory?>('splashFactory', splashFactory));
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
  }
}
