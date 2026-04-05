import 'package:flutter/material.dart';

/// A function type signature for resolving a custom painter to draw
/// background decorations for date ranges.
///
/// It takes the [textDirection] for layout purposes, the base [color] for
/// the decoration, and a [start] flag indicating if the cell is the
/// start or end date of the range.
typedef ResolvePainter = RangeDecorationPainter? Function(TextDirection textDirection, Color? color, bool start);

/// An abstract base class for custom painters that decorate range selections.
///
/// It extends [CustomPainter] and provides common properties for
/// drawing decorative elements behind date ranges.
abstract class RangeDecorationPainter extends CustomPainter {
  /// Creates a [RangeDecorationPainter].
  RangeDecorationPainter({
    required this.textDirection,
    required this.color,
    required this.start,
  });

  /// The text direction, used to determine the positioning of the decoration
  /// based on left-to-right or right-to-left layout.
  final TextDirection textDirection;

  /// The color of the decoration to be painted.
  final Color? color;

  /// A boolean value indicating whether the rectangle should be drawn
  /// at the start or end of a range selection.
  final bool start;
}

/// A custom painter class for decorating a widget with a colored rectangle.
///
/// The [RangeSelectionPainter] class extends [CustomPainter] and is responsible
/// for painting a colored rectangle on a canvas based on specified parameters.
/// This class is typically used as the painter for a [CustomPaint] widget to
/// achieve a customized visual effect.
///
/// ### Example:
///
/// ```dart
/// CustomPaint(
///   painter: RangeSelectionPainter(
///     textDirection: TextDirection.ltr,
///     color: Colors.blue,
///     start: true,
///   ),
///   child: // Your child widget goes here,
/// )
/// ```
class RangeSelectionPainter extends RangeDecorationPainter {
  /// Creates a [RangeSelectionPainter] with the specified parameters.
  ///
  /// The `textDirection` parameter is required to determine the positioning
  /// of the colored rectangle based on the text direction.
  ///
  /// The `color` parameter defines the color of the rectangle to be painted.
  ///
  /// The `start` parameter is a boolean value indicating whether the rectangle
  /// should be drawn at the start (left for LTR, right for RTL) or at the zero
  /// position of the canvas.
  RangeSelectionPainter({
    required super.textDirection,
    required super.color,
    required super.start,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width / 2;
    final height = size.height;

    final painter = Paint();
    if (color != null) {
      painter.color = color!;
    }

    final offset = switch (textDirection) {
      TextDirection.ltr => start ? Offset(width, 0) : Offset.zero,
      TextDirection.rtl => start ? Offset.zero : Offset(width, 0),
    };

    canvas.drawRect(offset & Size(width, height), painter);
  }

  @override
  bool shouldRepaint(covariant RangeDecorationPainter oldDelegate) {
    return oldDelegate.textDirection != textDirection || oldDelegate.color != color || oldDelegate.start != start;
  }
}
