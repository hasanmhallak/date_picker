import 'package:flutter/material.dart';

/// Shows indication about what year/month are opened.
class LeadingDate extends StatelessWidget {
  /// Shows indication about what year/month are opened.
  const LeadingDate({
    super.key,
    required this.displayedText,
    required this.onTap,
  });

  /// The year/month whose days are displayed by this picker.
  final String displayedText;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        displayedText,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
