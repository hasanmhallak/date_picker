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
    required this.rowExtent,
    required this.rowStride,
    this.columnPadding = 0,
    this.rowPadding = 0,
  });

  /// The number of columns in the cross axis.
  final int columnCount;

  /// The amount of padding between columns in the cross axis.
  final double columnPadding;

  /// The amount of padding between rows in the main axis.
  final double rowPadding;

  /// The number of pixels from the leading edge of one tile to the trailing edge of the same tile in the main axis.
  final double rowExtent;

  /// The number of pixels from the leading edge of one tile to the leading edge of the next tile in the main axis.
  final double rowStride;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = constraints.crossAxisExtent / columnCount;

    return SliverGridRegularTileLayout(
      // to add padding between cells.
      childCrossAxisExtent: tileWidth - columnPadding,
      childMainAxisExtent: rowExtent - rowPadding,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: rowStride,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerGridDelegate oldDelegate) => false;
}
