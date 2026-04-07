import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

import 'leading_date.dart';

Widget _headerArrowButton({
  required BuildContext context,
  required HeaderTheme? theme,
  required bool forward,
  required bool isEnabled,
  required VoidCallback onPressed,
  required Widget? child,
  required String semanticsLabel,
}) {
  final ink = forward ? theme?.forwardButtonInkResponseTheme : theme?.backwardButtonInkResponseTheme;
  final fallbackInk = InkResponseTheme.defaults(context);
  final i = ink ?? fallbackInk;
  final decoration = forward ? theme?.forwardButtonDecoration : theme?.backwardButtonDecoration;
  final width = forward ? theme?.forwardButtonWidth : theme?.backwardButtonWidth;
  final height = forward ? theme?.forwardButtonHeight : theme?.backwardButtonHeight;
  final resolvedDecoration = decoration ?? const ShapeDecoration(shape: CircleBorder());
  final materialShape = i.customBorder ?? (decoration?.shape ?? const CircleBorder());

  return Semantics(
    label: semanticsLabel,
    button: true,
    enabled: isEnabled,
    child: Ink(
      width: width ?? 36,
      height: height ?? 36,
      decoration: resolvedDecoration,
      child: InkResponse(
        onTap: isEnabled ? onPressed : null,
        radius: i.radius,
        splashColor: i.splashColor,
        highlightColor: i.highlightColor,
        borderRadius: i.borderRadius,
        containedInkWell: i.containedInkWell ?? true,
        customBorder: materialShape,
        highlightShape: i.highlightShape ?? BoxShape.circle,
        splashFactory: i.splashFactory,
        focusColor: i.focusColor,
        hoverColor: i.hoverColor,
        child: ExcludeSemantics(child: child ?? const SizedBox.shrink()),
      ),
    ),
  );
}

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

    final forwardButtonWidget = headerTheme?.forwardArrowWidget;
    final backwardButtonWidget = headerTheme?.backwardArrowWidget;

    final forwardButton = _headerArrowButton(
      context: context,
      theme: headerTheme,
      forward: true,
      isEnabled: isEnabled,
      onPressed: onNextPage,
      child: forwardButtonWidget,
      semanticsLabel: nextPageSemanticLabel,
    );

    final backButton = _headerArrowButton(
      context: context,
      theme: headerTheme,
      forward: false,
      isEnabled: isEnabled,
      onPressed: onPreviousPage,
      child: backwardButtonWidget,
      semanticsLabel: previousPageSemanticLabel,
    );

    final enableArrowKeys = headerTheme?.enableArrowKeys ?? true;
    final arrowButtonsSpace = headerTheme?.arrowButtonsSpace ?? 10;

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
              SizedBox(width: arrowButtonsSpace),
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
