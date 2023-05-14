import 'package:flutter/material.dart';

import 'leading_date.dart';
import 'page_sliders.dart';

class Header extends StatelessWidget {
  final String displayedDate;
  final VoidCallback onDateTap;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
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
