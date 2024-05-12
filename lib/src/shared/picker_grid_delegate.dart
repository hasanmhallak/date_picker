import 'dart:math' show min;

import 'package:flutter/rendering.dart';

/// A [SliverGridLayout] that uses equally sized and spaced tiles.
///
/// Rather that providing a grid with a [SliverGridLayout] directly, you instead
/// provide the grid a [SliverGridDelegate], which can compute a
/// [SliverGridLayout] given the current [SliverConstraints].
///
/// This layout is used by [SliverGridDelegateWithFixedCrossAxisCount] and
/// [SliverGridDelegateWithMaxCrossAxisExtent].
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
    // vertical padding between cells is 4px
    final double calculatedTileHeight =
        (constraints.viewportMainAxisExtent - rowCount * 4) / rowCount;

    // height should always be equal or less than the width
    // this is for range decoration.
    final double tileHeight = min(calculatedTileHeight, tileWidth);

    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      childCrossAxisExtent: _zeroOrGreater(tileWidth),
      crossAxisStride: _zeroOrGreater(tileWidth),
      childMainAxisExtent: _zeroOrGreater(tileHeight),
      mainAxisStride: _zeroOrGreater(tileHeight + 4),
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerGridDelegate oldDelegate) => false;

  // for when the keyboard is opened.
  double _zeroOrGreater(double number) {
    return number >= 0 ? number : 0;
  }
}
