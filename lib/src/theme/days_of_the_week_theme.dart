import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The length of the weekday strings to display.
enum WeekdayLength {
  /// e.g. "Monday"
  long,

  /// e.g. "Mon"
  short,

  /// e.g. "M"
  narrow,
}

/// A theme that controls the visual appearance of the "M T W T F S S" row.
@immutable
class DaysOfTheWeekTheme extends ThemeExtension<DaysOfTheWeekTheme>
    with DiagnosticableTreeMixin {
  /// Creates a [DaysOfTheWeekTheme].
  const DaysOfTheWeekTheme({
    this.startOfWeek,
    this.textStyle,
    this.decoration,
    this.weekdayLength,
  });

  /// ISO 8601 weekday number (1 = Monday, 7 = Sunday) to start the week.
  ///
  /// Defaults to the value from [MaterialLocalizations.firstDayOfWeekIndex].
  final int? startOfWeek;

  /// The text style of the days of the week in the header.
  ///
  /// defaults to [TextTheme.titleSmall] with a [FontWeight.bold],
  /// a `14` font size, and a [ColorScheme.onSurface] with 30% opacity.
  final TextStyle? textStyle;

  /// The decoration of the weekday label, such as background color or shape.
  ///
  /// defaults to empty [BoxDecoration].
  final Decoration? decoration;

  /// The length format of the weekday.
  final WeekdayLength? weekdayLength;

  /// Returns a [DaysOfTheWeekTheme] populated with default values.
  static DaysOfTheWeekTheme defaults(BuildContext context) {
    final theme = Theme.of(context);
    final startOfWeek = MaterialLocalizations.of(context).firstDayOfWeekIndex;

    return DaysOfTheWeekTheme(
      startOfWeek: startOfWeek == 0 ? 7 : startOfWeek,
      textStyle: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      ),
      decoration: const BoxDecoration(),
      weekdayLength: WeekdayLength.short,
    );
  }

  @override
  DaysOfTheWeekTheme copyWith({
    int? startOfWeek,
    TextStyle? textStyle,
    Decoration? decoration,
    WeekdayLength? weekdayLength,
  }) {
    return DaysOfTheWeekTheme(
      startOfWeek: startOfWeek ?? this.startOfWeek,
      textStyle: textStyle ?? this.textStyle,
      decoration: decoration ?? this.decoration,
      weekdayLength: weekdayLength ?? this.weekdayLength,
    );
  }

  /// Merges the properties of [other] into this theme.
  DaysOfTheWeekTheme merge(covariant DaysOfTheWeekTheme? other) {
    if (other == null) return this;
    return copyWith(
      startOfWeek: other.startOfWeek,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      decoration: other.decoration,
      weekdayLength: other.weekdayLength,
    );
  }

  @override
  DaysOfTheWeekTheme lerp(
      covariant ThemeExtension<DaysOfTheWeekTheme>? other, double t) {
    if (other is! DaysOfTheWeekTheme) return this;

    return DaysOfTheWeekTheme(
      startOfWeek: t < 0.5 ? startOfWeek : other.startOfWeek,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      weekdayLength: t < 0.5 ? weekdayLength : other.weekdayLength,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('startOfWeek', startOfWeek));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<Decoration?>('decoration', decoration));
    properties
        .add(EnumProperty<WeekdayLength?>('weekdayLength', weekdayLength));
  }
}
