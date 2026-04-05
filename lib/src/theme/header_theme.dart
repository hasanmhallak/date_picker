import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    this.forwardButtonStyle,
    this.backwardButtonStyle,
    this.headerPadding,
    this.decoration,
  });

  /// Whether the header is enabled and visible.
  ///
  /// Defaults to `true`.
  final bool? enableHeader;

  /// Whether to show the forward/backward page sliders (arrow buttons)
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

  /// The button style for the forward arrow button.
  ///
  /// Defaults to a [TextButton] style with no padding, circular shape,
  /// and the primary color as the foreground color.
  final ButtonStyle? forwardButtonStyle;

  /// The button style for the backward arrow button.
  ///
  /// Defaults to a [TextButton] style with no padding, circular shape,
  /// and the primary color as the foreground color.
  final ButtonStyle? backwardButtonStyle;

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
      forwardButtonStyle: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(36, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        foregroundColor: theme.colorScheme.primary,
      ),
      backwardButtonStyle: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(36, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const CircleBorder(),
        foregroundColor: theme.colorScheme.primary,
      ),
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
    ButtonStyle? forwardButtonStyle,
    ButtonStyle? backwardButtonStyle,
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
      forwardButtonStyle: forwardButtonStyle ?? this.forwardButtonStyle,
      backwardButtonStyle: backwardButtonStyle ?? this.backwardButtonStyle,
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
      forwardButtonStyle: forwardButtonStyle != null
          ? forwardButtonStyle!.copyWith(
              textStyle: other.forwardButtonStyle?.textStyle,
              backgroundColor: other.forwardButtonStyle?.backgroundColor,
              foregroundColor: other.forwardButtonStyle?.foregroundColor,
              overlayColor: other.forwardButtonStyle?.overlayColor,
              shadowColor: other.forwardButtonStyle?.shadowColor,
              surfaceTintColor: other.forwardButtonStyle?.surfaceTintColor,
              elevation: other.forwardButtonStyle?.elevation,
              padding: other.forwardButtonStyle?.padding,
              minimumSize: other.forwardButtonStyle?.minimumSize,
              fixedSize: other.forwardButtonStyle?.fixedSize,
              maximumSize: other.forwardButtonStyle?.maximumSize,
              iconColor: other.forwardButtonStyle?.iconColor,
              iconSize: other.forwardButtonStyle?.iconSize,
              side: other.forwardButtonStyle?.side,
              shape: other.forwardButtonStyle?.shape,
              mouseCursor: other.forwardButtonStyle?.mouseCursor,
              visualDensity: other.forwardButtonStyle?.visualDensity,
              tapTargetSize: other.forwardButtonStyle?.tapTargetSize,
              animationDuration: other.forwardButtonStyle?.animationDuration,
              enableFeedback: other.forwardButtonStyle?.enableFeedback,
              alignment: other.forwardButtonStyle?.alignment,
              splashFactory: other.forwardButtonStyle?.splashFactory,
            )
          : other.forwardButtonStyle,
      backwardButtonStyle: backwardButtonStyle != null
          ? backwardButtonStyle!.copyWith(
              textStyle: other.backwardButtonStyle?.textStyle,
              backgroundColor: other.backwardButtonStyle?.backgroundColor,
              foregroundColor: other.backwardButtonStyle?.foregroundColor,
              overlayColor: other.backwardButtonStyle?.overlayColor,
              shadowColor: other.backwardButtonStyle?.shadowColor,
              surfaceTintColor: other.backwardButtonStyle?.surfaceTintColor,
              elevation: other.backwardButtonStyle?.elevation,
              padding: other.backwardButtonStyle?.padding,
              minimumSize: other.backwardButtonStyle?.minimumSize,
              fixedSize: other.backwardButtonStyle?.fixedSize,
              maximumSize: other.backwardButtonStyle?.maximumSize,
              iconColor: other.backwardButtonStyle?.iconColor,
              iconSize: other.backwardButtonStyle?.iconSize,
              side: other.backwardButtonStyle?.side,
              shape: other.backwardButtonStyle?.shape,
              mouseCursor: other.backwardButtonStyle?.mouseCursor,
              visualDensity: other.backwardButtonStyle?.visualDensity,
              tapTargetSize: other.backwardButtonStyle?.tapTargetSize,
              animationDuration: other.backwardButtonStyle?.animationDuration,
              enableFeedback: other.backwardButtonStyle?.enableFeedback,
              alignment: other.backwardButtonStyle?.alignment,
              splashFactory: other.backwardButtonStyle?.splashFactory,
            )
          : other.backwardButtonStyle,
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
      forwardButtonStyle: ButtonStyle.lerp(forwardButtonStyle, other.forwardButtonStyle, t),
      backwardButtonStyle: ButtonStyle.lerp(backwardButtonStyle, other.backwardButtonStyle, t),
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
    properties.add(DiagnosticsProperty<ButtonStyle?>('forwardButtonStyle', forwardButtonStyle));
    properties.add(DiagnosticsProperty<ButtonStyle?>('backwardButtonStyle', backwardButtonStyle));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('headerPadding', headerPadding));
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
  }
}
