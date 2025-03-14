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
///   centerLeadingDate: true,
///   onDateTap: () {
///     // Handle date tap action
///   },
///   onNextPage: () {
///     // Handle next page navigation
///   },
///   onPreviousPage: () {
///     // Handle previous page navigation
///   },
///   slidersColor: Colors.blue,
///   slidersSize: 20.0,
///   leadingDateTextStyle: TextStyle(
///     fontWeight: FontWeight.bold,
///     fontSize: 18.0,
///   ),
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
  ///
  /// The [displayedDate], [onDateTap], [onNextPage], [onPreviousPage], [slidersColor],
  /// [slidersSize], and [leadingDateTextStyle] parameters are required.
  const Header({
    super.key,
    required this.displayedDate,
    required this.onDateTap,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.slidersColor,
    required this.slidersSize,
    required this.leadingDateTextStyle,
    this.centerLeadingDate = false,
    this.previousPageSemanticLabel,
    this.nextPageSemanticLabel,
  });

  /// The currently displayed date. It is typically in a format
  /// indicating the month and year.
  final String displayedDate;

  /// the text style for the [displayedDate] in the header.
  final TextStyle leadingDateTextStyle;

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

  /// The color of the page navigation sliders
  /// (forward and backward).
  final Color slidersColor;

  /// The size of the page navigation sliders
  /// (forward and backward).
  final double slidersSize;

  /// Centring the leading date. e.g:
  ///
  /// <       December 2023      >
  ///
  final bool centerLeadingDate;

  /// Semantic label for button to go to the previous page.
  final String? previousPageSemanticLabel;

  /// Semantic label for button to go to the next page.
  final String? nextPageSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final forwardButton = GestureDetector(
      onTap: onNextPage,
      child: SizedBox(
        width: 36,
        height: 36,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: slidersSize,
            color: slidersColor,
          ),
        ),
      ),
    );

    final backButton = GestureDetector(
      onTap: onPreviousPage,
      child: SizedBox(
        width: 36,
        height: 36,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: slidersSize,
            color: slidersColor,
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (centerLeadingDate) backButton,
        LeadingDate(
          onTap: onDateTap,
          displayedText: displayedDate,
          displayedTextStyle: leadingDateTextStyle,
        ),
        if (centerLeadingDate)
          forwardButton
        else
          Row(
            children: [
              backButton,
              const SizedBox(width: 10),
              forwardButton,
            ],
          ),
      ],
    );
  }
}
