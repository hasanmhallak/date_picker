import 'package:flutter/material.dart';

/// The `LeadingDate` class is a widget that shows an indication of the opened year/month
/// above a calendar grid. It is typically used as part of a header in a calendar display.
///
/// ### Example:
///
/// ```dart
/// LeadingDate(
///   displayedText: "December 2023",
///   onTap: () {
///     // Handle date tap action
///   },
///   displayedTextStyle: TextStyle(
///     fontWeight: FontWeight.bold,
///     fontSize: 18.0,
///   ),
/// )
/// ```
///
/// The `LeadingDate` widget presents the year/month text in a styled manner and allows for interaction
/// through the provided `onTap` callback.
///
class LeadingDate extends StatelessWidget {
  /// Creates a new [LeadingDate] instance.
  ///
  /// The [displayedText], [onTap], and [displayedTextStyle] parameters are required.
  const LeadingDate({
    Key? key,
    required this.displayedText,
    required this.onTap,
    required this.displayedTextStyle,
  }) : super(key: key);

  /// The year/month whose days are displayed by this picker.
  final String displayedText;

  /// The text style of [displayedText].
  final TextStyle displayedTextStyle;

  /// A callback function that is triggered when the user taps on the displayed date or month.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        displayedText,
        style: displayedTextStyle,
      ),
    );
  }
}
