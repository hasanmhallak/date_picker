import 'package:flutter/material.dart';

import 'leading_date.dart';
import 'page_sliders.dart';

/// The header that will be shown above the calendar grid.
///
///
/// See also:
///
///  * [LeadingDate], which shows indication about what year/month are opened.
///
/// * [PageSliders], which controlls the next & previous page.
///
class Header extends StatelessWidget {
  final String displayedDate;
  final VoidCallback onDateTap;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;

  /// The header that will be shown above the calendar grid.
  const Header({
    super.key,
    required this.displayedDate,
    required this.onDateTap,
    required this.onNextPage,
    required this.onPreviousPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LeadingDate(
          onTap: onDateTap,
          displayedText: displayedDate,
        ),
        PageSliders(
          onBackward: onPreviousPage,
          onForward: onNextPage,
        ),
      ],
    );
  }
}
