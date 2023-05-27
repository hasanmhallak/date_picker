import 'package:flutter/cupertino.dart';

/// Controlls the next & previous page.
class PageSliders extends StatelessWidget {
  final VoidCallback onForward;
  final VoidCallback onBackward;
  final Color slidersColor;
  final double slidersSized;

  /// Controlls the next & previous page.
  const PageSliders({
    Key? key,
    required this.onForward,
    required this.onBackward,
    required this.slidersColor,
    required this.slidersSized,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onBackward,
            child: SizedBox(
              width: 36,
              height: 36,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  size: slidersSized,
                  color: slidersColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: onForward,
            child: SizedBox(
              width: 36,
              height: 36,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.chevron_right,
                  size: slidersSized,
                  color: slidersColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
