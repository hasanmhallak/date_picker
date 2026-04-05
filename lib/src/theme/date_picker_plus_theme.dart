import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'days_picker_theme.dart';
import 'header_theme.dart';
import 'months_picker_theme.dart';
import 'range_picker_theme.dart';
import 'years_picker_theme.dart';

/// The top-level theme for `date_picker_plus`.
///
/// Contains themes for the header, days of the week, days grid,
/// months grid, years grid, and range picker days grid.
@immutable
class DatePickerPlusTheme extends ThemeExtension<DatePickerPlusTheme> with DiagnosticableTreeMixin {
  /// Creates a [DatePickerPlusTheme].
  const DatePickerPlusTheme({
    this.headerTheme,
    this.daysPickerTheme,
    this.monthsPickerTheme,
    this.yearsPickerTheme,
    this.rangePickerTheme,
    this.isEnabled,
  });

  /// When `false`, the picker is view-only: no taps, navigation, or swipes.
  ///
  /// Defaults to `true`.
  final bool? isEnabled;

  /// The theme controlling the header's appearance.
  final HeaderTheme? headerTheme;

  /// The theme controlling the grid of days.
  final DaysPickerTheme? daysPickerTheme;

  /// The theme controlling the grid of months.
  final MonthsPickerTheme? monthsPickerTheme;

  /// The theme controlling the grid of years.
  final YearsPickerTheme? yearsPickerTheme;

  /// The theme controlling the grid of days in a range selection.
  final RangePickerTheme? rangePickerTheme;

  /// Returns a [DatePickerPlusTheme] populated with default internal themes.
  static DatePickerPlusTheme defaults(BuildContext context) {
    return DatePickerPlusTheme(
      headerTheme: HeaderTheme.defaults(context),
      daysPickerTheme: DaysPickerTheme.defaults(context),
      monthsPickerTheme: MonthsPickerTheme.defaults(context),
      yearsPickerTheme: YearsPickerTheme.defaults(context),
      rangePickerTheme: RangePickerTheme.defaults(context),
      isEnabled: true,
    );
  }

  @override
  DatePickerPlusTheme copyWith({
    HeaderTheme? headerTheme,
    DaysPickerTheme? daysPickerTheme,
    MonthsPickerTheme? monthsPickerTheme,
    YearsPickerTheme? yearsPickerTheme,
    RangePickerTheme? rangePickerTheme,
    bool? isEnabled,
  }) {
    return DatePickerPlusTheme(
      headerTheme: headerTheme ?? this.headerTheme,
      daysPickerTheme: daysPickerTheme ?? this.daysPickerTheme,
      monthsPickerTheme: monthsPickerTheme ?? this.monthsPickerTheme,
      yearsPickerTheme: yearsPickerTheme ?? this.yearsPickerTheme,
      rangePickerTheme: rangePickerTheme ?? this.rangePickerTheme,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// Merges the properties of [other] into this theme, recursively
  /// merging each sub-theme.
  DatePickerPlusTheme merge(covariant DatePickerPlusTheme? other) {
    if (other == null) return this;
    return copyWith(
      headerTheme: headerTheme?.merge(other.headerTheme) ?? other.headerTheme,
      daysPickerTheme: daysPickerTheme?.merge(other.daysPickerTheme) ?? other.daysPickerTheme,
      monthsPickerTheme: monthsPickerTheme?.merge(other.monthsPickerTheme) ?? other.monthsPickerTheme,
      yearsPickerTheme: yearsPickerTheme?.merge(other.yearsPickerTheme) ?? other.yearsPickerTheme,
      rangePickerTheme: rangePickerTheme?.merge(other.rangePickerTheme) ?? other.rangePickerTheme,
      isEnabled: other.isEnabled ?? isEnabled,
    );
  }

  @override
  DatePickerPlusTheme lerp(covariant ThemeExtension<DatePickerPlusTheme>? other, double t) {
    if (other is! DatePickerPlusTheme) return this;

    return DatePickerPlusTheme(
      headerTheme: headerTheme?.lerp(other.headerTheme, t),
      daysPickerTheme: daysPickerTheme?.lerp(other.daysPickerTheme, t),
      monthsPickerTheme: monthsPickerTheme?.lerp(other.monthsPickerTheme, t),
      yearsPickerTheme: yearsPickerTheme?.lerp(other.yearsPickerTheme, t),
      rangePickerTheme: rangePickerTheme?.lerp(other.rangePickerTheme, t),
      isEnabled: t < 0.5 ? isEnabled : other.isEnabled,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<HeaderTheme?>('headerTheme', headerTheme));
    properties.add(DiagnosticsProperty<DaysPickerTheme?>('daysPickerTheme', daysPickerTheme));
    properties.add(DiagnosticsProperty<MonthsPickerTheme?>('monthsPickerTheme', monthsPickerTheme));
    properties.add(DiagnosticsProperty<YearsPickerTheme?>('yearsPickerTheme', yearsPickerTheme));
    properties.add(DiagnosticsProperty<RangePickerTheme?>('rangePickerTheme', rangePickerTheme));
    properties.add(DiagnosticsProperty<bool?>('isEnabled', isEnabled));
  }
}
