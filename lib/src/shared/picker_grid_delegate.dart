import 'package:flutter/rendering.dart';

/// A [SliverGridDelegate] that divides the viewport into a fixed number of
/// equally sized rows and columns.
///
/// Tile width is derived from the cross-axis extent and [columnCount]; tile
/// height is derived from the main-axis extent and [rowCount]. The two
/// dimensions are independent, so tiles may be non-square when the picker's
/// aspect ratio is not `columnCount / rowCount`.
///
/// **Non-square tiles and the range picker.** When tiles are taller than they
/// are wide the default circle decoration on selected edge cells will be
/// smaller than the rectangle painted by [RangeSelectionPainter], because the
/// circle is inscribed in the cell's shorter dimension. To avoid this visual
/// mismatch you can:
///
///  * Use an oval [OvalBorder] (or [StadiumBorder]) for
///    [RangePickerTheme.selectedEdgeCellDecoration] so the decoration fills
///    the full cell bounds.
///  * Provide a custom [RangePickerTheme.resolvePainter] that accounts for the
///    cell aspect ratio.
///
/// See also:
///
///  * [SliverGridDelegateWithFixedCrossAxisCount], which uses this layout.
///  * [SliverGridDelegateWithMaxCrossAxisExtent], which uses this layout.
///  * [SliverGridLayout], which represents an arbitrary tile layout.
///  * [SliverGridGeometry], which represents the size and position of a single
///    tile in a grid.
///  * [SliverGridDelegate.getLayout], which returns this object to describe the
///    delegate's layout.
///  * [RenderSliverGrid], which uses this class during its
///    [RenderSliverGrid.performLayout] method.
class PickerGridDelegate extends SliverGridDelegate {
  /// Creates a layout that uses equally sized and spaced tiles.
  ///
  /// All of the arguments must not be null and must not be negative.
  /// The crossAxisCount argument must be greater than zero.
  const PickerGridDelegate({
    required this.columnCount,
    required this.rowCount,
  });

  final int rowCount;

  final int columnCount;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    final double calculatedTileHeight = (constraints.viewportMainAxisExtent) / rowCount;

    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      childCrossAxisExtent: _zeroOrGreater(tileWidth),
      crossAxisStride: _zeroOrGreater(tileWidth),
      childMainAxisExtent: _zeroOrGreater(calculatedTileHeight),
      mainAxisStride: _zeroOrGreater(calculatedTileHeight),
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerGridDelegate oldDelegate) {
    return columnCount != oldDelegate.columnCount || rowCount != oldDelegate.rowCount;
  }

  // for when the keyboard is opened.
  double _zeroOrGreater(double number) {
    return number >= 0 ? number : 0;
  }
}
