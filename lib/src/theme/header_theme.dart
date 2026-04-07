import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ink_response_theme.dart';

/// A theme that controls the visual appearance of the header in picker views.
@immutable
class HeaderTheme extends ThemeExtension<HeaderTheme> with DiagnosticableTreeMixin {
  /// Creates a [HeaderTheme].
  const HeaderTheme({
    this.enableHeader,
    this.enableArrowKeys,
    this.forwardArrowWidget,
    this.backwardArrowWidget,
    this.centerLeadingDate,
    this.leadingDateTextStyle,
    this.forwardButtonDecoration,
    this.backwardButtonDecoration,
    this.forwardButtonWidth,
    this.backwardButtonWidth,
    this.forwardButtonHeight,
    this.backwardButtonHeight,
    this.forwardButtonInkResponseTheme,
    this.backwardButtonInkResponseTheme,
    this.arrowButtonsSpace,
    this.headerPadding,
    this.decoration,
  });

  /// Whether the header is enabled and visible.
  ///
  /// Defaults to `true`.
  final bool? enableHeader;

  /// Whether to show the forward/backward arrow buttons
  /// for changing the month/year being displayed.
  ///
  /// Defaults to `true`.
  final bool? enableArrowKeys;

  /// A custom widget to use for the forward (next page) arrow button.
  ///
  /// Default to [Icons.arrow_forward_ios_rounded] with
  /// [Theme.of(context).colorScheme.primary] color and size 20.
  final Widget? forwardArrowWidget;

  /// A custom widget to use for the backward (previous page) arrow button.
  ///
  /// Default to [Icons.arrow_back_ios_rounded] with
  /// [Theme.of(context).colorScheme.primary] color and size 20.
  final Widget? backwardArrowWidget;

  /// Centring the leading date. e.g.:
  ///
  /// `<       December 2023      >`
  ///
  /// Defaults to `false`.
  final bool? centerLeadingDate;

  /// The text style of leading date showing in the header.
  ///
  /// Defaults to `18px` with a [FontWeight.bold]
  /// and [ColorScheme.primary] color.
  final TextStyle? leadingDateTextStyle;

  /// Background decoration for the forward (next page) arrow button.
  ///
  /// Defaults to a circular [ShapeDecoration]. Use [ShapeDecoration.shape] so
  /// ink splashes match the painted outline.
  final ShapeDecoration? forwardButtonDecoration;

  /// Background decoration for the backward (previous page) arrow button.
  ///
  /// Defaults to a circular [ShapeDecoration]. Use [ShapeDecoration.shape] so
  /// ink splashes match the painted outline.
  final ShapeDecoration? backwardButtonDecoration;

  /// Width of the forward arrow button.
  ///
  /// Defaults to `36`.
  final double? forwardButtonWidth;

  /// Width of the backward arrow button.
  ///
  /// Defaults to `36`.
  final double? backwardButtonWidth;

  /// Height of the forward arrow button.
  ///
  /// Defaults to `36`.
  final double? forwardButtonHeight;

  /// Height of the backward arrow button.
  ///
  /// Defaults to `36`.
  final double? backwardButtonHeight;

  /// Splash and highlight for the forward arrow button [InkResponse].
  final InkResponseTheme? forwardButtonInkResponseTheme;

  /// Splash and highlight for the backward arrow button [InkResponse].
  final InkResponseTheme? backwardButtonInkResponseTheme;

  /// Horizontal gap between the backward and forward arrow buttons when both are on the same side.
  ///
  /// Defaults to `10`.
  final double? arrowButtonsSpace;

  /// The padding of the header.
  ///
  /// Defaults to `EdgeInsets.only(bottom: 10.0)`.
  final EdgeInsetsGeometry? headerPadding;

  /// The decoration behind the header content (inside [headerPadding]).
  ///
  /// Defaults to an empty [BoxDecoration].
  final Decoration? decoration;

  /// Returns a [HeaderTheme] populated with default values.
  static HeaderTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final inkDefaults = InkResponseTheme.defaults(context).copyWith(containedInkWell: true);

    return HeaderTheme(
      enableHeader: true,
      enableArrowKeys: true,
      headerPadding: const EdgeInsetsDirectional.only(bottom: 10.0),
      decoration: const BoxDecoration(),
      forwardArrowWidget: Icon(
        Icons.arrow_forward_ios_rounded,
        color: theme.colorScheme.primary,
        size: 20,
      ),
      backwardArrowWidget: Icon(
        Icons.arrow_back_ios_rounded,
        color: theme.colorScheme.primary,
        size: 20,
      ),
      centerLeadingDate: false,
      leadingDateTextStyle: textTheme.titleMedium?.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
      forwardButtonDecoration: const ShapeDecoration(shape: CircleBorder()),
      backwardButtonDecoration: const ShapeDecoration(shape: CircleBorder()),
      forwardButtonWidth: 36,
      backwardButtonWidth: 36,
      forwardButtonHeight: 36,
      backwardButtonHeight: 36,
      forwardButtonInkResponseTheme: inkDefaults,
      backwardButtonInkResponseTheme: inkDefaults,
      arrowButtonsSpace: 10,
    );
  }

  @override
  HeaderTheme copyWith({
    bool? enableHeader,
    bool? enableArrowKeys,
    Widget? forwardArrowWidget,
    Widget? backwardArrowWidget,
    bool? centerLeadingDate,
    TextStyle? leadingDateTextStyle,
    ShapeDecoration? forwardButtonDecoration,
    ShapeDecoration? backwardButtonDecoration,
    double? forwardButtonWidth,
    double? backwardButtonWidth,
    double? forwardButtonHeight,
    double? backwardButtonHeight,
    InkResponseTheme? forwardButtonInkResponseTheme,
    InkResponseTheme? backwardButtonInkResponseTheme,
    double? arrowButtonsSpace,
    EdgeInsetsGeometry? headerPadding,
    Decoration? decoration,
  }) {
    return HeaderTheme(
      enableHeader: enableHeader ?? this.enableHeader,
      enableArrowKeys: enableArrowKeys ?? this.enableArrowKeys,
      forwardArrowWidget: forwardArrowWidget ?? this.forwardArrowWidget,
      backwardArrowWidget: backwardArrowWidget ?? this.backwardArrowWidget,
      centerLeadingDate: centerLeadingDate ?? this.centerLeadingDate,
      leadingDateTextStyle: leadingDateTextStyle ?? this.leadingDateTextStyle,
      forwardButtonDecoration: forwardButtonDecoration ?? this.forwardButtonDecoration,
      backwardButtonDecoration: backwardButtonDecoration ?? this.backwardButtonDecoration,
      forwardButtonWidth: forwardButtonWidth ?? this.forwardButtonWidth,
      backwardButtonWidth: backwardButtonWidth ?? this.backwardButtonWidth,
      forwardButtonHeight: forwardButtonHeight ?? this.forwardButtonHeight,
      backwardButtonHeight: backwardButtonHeight ?? this.backwardButtonHeight,
      forwardButtonInkResponseTheme: forwardButtonInkResponseTheme ?? this.forwardButtonInkResponseTheme,
      backwardButtonInkResponseTheme: backwardButtonInkResponseTheme ?? this.backwardButtonInkResponseTheme,
      arrowButtonsSpace: arrowButtonsSpace ?? this.arrowButtonsSpace,
      headerPadding: headerPadding ?? this.headerPadding,
      decoration: decoration ?? this.decoration,
    );
  }

  /// Merges the properties of [other] into this theme.
  HeaderTheme merge(covariant HeaderTheme? other) {
    if (other == null) return this;
    return copyWith(
      enableHeader: other.enableHeader,
      enableArrowKeys: other.enableArrowKeys,
      forwardArrowWidget: other.forwardArrowWidget,
      backwardArrowWidget: other.backwardArrowWidget,
      centerLeadingDate: other.centerLeadingDate,
      leadingDateTextStyle: leadingDateTextStyle?.merge(other.leadingDateTextStyle) ?? other.leadingDateTextStyle,
      headerPadding: other.headerPadding,
      decoration: other.decoration,
      forwardButtonDecoration: other.forwardButtonDecoration,
      backwardButtonDecoration: other.backwardButtonDecoration,
      forwardButtonWidth: other.forwardButtonWidth,
      backwardButtonWidth: other.backwardButtonWidth,
      forwardButtonHeight: other.forwardButtonHeight,
      backwardButtonHeight: other.backwardButtonHeight,
      forwardButtonInkResponseTheme: forwardButtonInkResponseTheme?.merge(other.forwardButtonInkResponseTheme) ??
          other.forwardButtonInkResponseTheme,
      backwardButtonInkResponseTheme: backwardButtonInkResponseTheme?.merge(other.backwardButtonInkResponseTheme) ??
          other.backwardButtonInkResponseTheme,
      arrowButtonsSpace: other.arrowButtonsSpace,
    );
  }

  @override
  HeaderTheme lerp(covariant ThemeExtension<HeaderTheme>? other, double t) {
    if (other is! HeaderTheme) return this;

    return HeaderTheme(
      enableHeader: t < 0.5 ? enableHeader : other.enableHeader,
      enableArrowKeys: t < 0.5 ? enableArrowKeys : other.enableArrowKeys,
      forwardArrowWidget: t < 0.5 ? forwardArrowWidget : other.forwardArrowWidget,
      backwardArrowWidget: t < 0.5 ? backwardArrowWidget : other.backwardArrowWidget,
      centerLeadingDate: t < 0.5 ? centerLeadingDate : other.centerLeadingDate,
      leadingDateTextStyle: TextStyle.lerp(leadingDateTextStyle, other.leadingDateTextStyle, t),
      forwardButtonDecoration: ShapeDecoration.lerp(forwardButtonDecoration, other.forwardButtonDecoration, t),
      backwardButtonDecoration: ShapeDecoration.lerp(backwardButtonDecoration, other.backwardButtonDecoration, t),
      forwardButtonWidth: lerpDouble(forwardButtonWidth, other.forwardButtonWidth, t),
      backwardButtonWidth: lerpDouble(backwardButtonWidth, other.backwardButtonWidth, t),
      forwardButtonHeight: lerpDouble(forwardButtonHeight, other.forwardButtonHeight, t),
      backwardButtonHeight: lerpDouble(backwardButtonHeight, other.backwardButtonHeight, t),
      forwardButtonInkResponseTheme: forwardButtonInkResponseTheme?.lerp(other.forwardButtonInkResponseTheme, t),
      backwardButtonInkResponseTheme: backwardButtonInkResponseTheme?.lerp(other.backwardButtonInkResponseTheme, t),
      arrowButtonsSpace: lerpDouble(arrowButtonsSpace, other.arrowButtonsSpace, t),
      headerPadding: EdgeInsetsGeometry.lerp(headerPadding, other.headerPadding, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool?>('enableHeader', enableHeader));
    properties.add(DiagnosticsProperty<bool?>('enableArrowKeys', enableArrowKeys));
    properties.add(DiagnosticsProperty<Widget?>('forwardArrowWidget', forwardArrowWidget));
    properties.add(DiagnosticsProperty<Widget?>('backwardArrowWidget', backwardArrowWidget));
    properties.add(DiagnosticsProperty<bool?>('centerLeadingDate', centerLeadingDate));
    properties.add(DiagnosticsProperty<TextStyle?>('leadingDateTextStyle', leadingDateTextStyle));
    properties.add(DiagnosticsProperty<ShapeDecoration?>('forwardButtonDecoration', forwardButtonDecoration));
    properties.add(DiagnosticsProperty<ShapeDecoration?>('backwardButtonDecoration', backwardButtonDecoration));
    properties.add(DoubleProperty('forwardButtonWidth', forwardButtonWidth));
    properties.add(DoubleProperty('backwardButtonWidth', backwardButtonWidth));
    properties.add(DoubleProperty('forwardButtonHeight', forwardButtonHeight));
    properties.add(DoubleProperty('backwardButtonHeight', backwardButtonHeight));
    properties
        .add(DiagnosticsProperty<InkResponseTheme?>('forwardButtonInkResponseTheme', forwardButtonInkResponseTheme));
    properties
        .add(DiagnosticsProperty<InkResponseTheme?>('backwardButtonInkResponseTheme', backwardButtonInkResponseTheme));
    properties.add(DoubleProperty('arrowButtonsSpace', arrowButtonsSpace));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('headerPadding', headerPadding));
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
  }
}
