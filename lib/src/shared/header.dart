import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import 'leading_date.dart';

/// The `Header` class represents the header widget that is displayed above the calendar grid.
///
/// This widget includes information about the currently displayed date, as well as navigation controls
/// for moving to the next or previous page in the calendar.
///
/// ### Example:
///
/// ```dart
/// Header(
///   displayedDate: "December 2023",
///   onDateTap: () {
///     // Handle date tap action
///   },
///   onNextPage: () {
///     // Handle next page navigation
///   },
///   onPreviousPage: () {
///     // Handle previous page navigation
///   },
///   theme: DatePickerPlusTheme.defaults(context),
/// )
/// ```
///
/// See also:
///
///  * [LeadingDate], a widget that shows an indication of the opened year/month.
///
///
class Header extends StatelessWidget {
  /// Creates a new [Header] instance.
  const Header({
    super.key,
    required this.displayedDate,
    required this.onDateTap,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.theme,
    this.isEnabled = true,
  });

  /// The currently displayed date. It is typically in a format
  /// indicating the month and year.
  final String displayedDate;

  /// Called when the displayed date is tapped. This can
  /// be used to trigger actions related to selecting or
  /// interacting with the displayed date.
  final VoidCallback onDateTap;

  /// called when the user wants to navigate to the next
  /// page in the calendar. This function is associated
  /// with the forward navigation control.
  final VoidCallback onNextPage;

  /// called when the user wants to navigate to the
  /// previous page in the calendar. This function is
  /// associated with the backward navigation control.
  final VoidCallback onPreviousPage;

  /// The theme to apply to the [DatePicker].
  ///
  /// If provided, it will be merged with the context's [DatePickerPlusTheme]
  /// and the default theme.
  final HeaderTheme? theme;

  /// When `false`, header navigation and leading date taps are disabled.
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final defaultTheme = DatePickerPlusTheme.defaults(context).headerTheme;
    final contextTheme = Theme.of(context).extension<DatePickerPlusTheme>()?.headerTheme;
    final theme = defaultTheme?.merge(contextTheme).merge(this.theme);

    final headerTheme = theme;
    final enableHeader = headerTheme?.enableHeader ?? true;
    if (!enableHeader) {
      return const SizedBox.shrink();
    }

    final centerLeadingDate = headerTheme?.centerLeadingDate;
    final nextPageSemanticLabel = MaterialLocalizations.of(context).nextPageTooltip;
    final previousPageSemanticLabel = MaterialLocalizations.of(context).previousPageTooltip;

    final forwardButtonStyle = headerTheme?.forwardButtonStyle;
    final backwardButtonStyle = headerTheme?.backwardButtonStyle;

    final forwardButtonWidget = headerTheme?.forwardArrowWidget;
    final backwardButtonWidget = headerTheme?.backwardArrowWidget;

    final forwardButton = Semantics(
      label: nextPageSemanticLabel,
      button: true,
      enabled: isEnabled,
      child: TextButton(
        onPressed: isEnabled ? onNextPage : null,
        style: forwardButtonStyle,
        child: ExcludeSemantics(child: forwardButtonWidget),
      ),
    );

    final backButton = Semantics(
      label: previousPageSemanticLabel,
      button: true,
      enabled: isEnabled,
      child: TextButton(
        onPressed: isEnabled ? onPreviousPage : null,
        style: backwardButtonStyle,
        child: ExcludeSemantics(child: backwardButtonWidget),
      ),
    );

    final enableArrowKeys = headerTheme?.enableArrowKeys ?? true;

    final leadingDate = LeadingDate(
      onTap: isEnabled ? onDateTap : null,
      displayedText: displayedDate,
      displayedTextStyle: headerTheme?.leadingDateTextStyle,
    );

    final List<Widget> trailingArrows = [];
    if (enableArrowKeys) {
      if (centerLeadingDate == true) {
        trailingArrows.add(forwardButton);
      } else {
        trailingArrows.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              backButton,
              const SizedBox(width: 10),
              forwardButton,
            ],
          ),
        );
      }
    }

    return DecoratedBox(
      decoration: headerTheme?.decoration ?? const BoxDecoration(),
      child: Padding(
        padding: headerTheme?.headerPadding ?? EdgeInsets.zero,
        child: centerLeadingDate == true && !enableArrowKeys
            ? Center(child: leadingDate)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (centerLeadingDate == true && enableArrowKeys) backButton,
                  Flexible(child: leadingDate),
                  ...trailingArrows,
                ],
              ),
      ),
    );
  }
}
