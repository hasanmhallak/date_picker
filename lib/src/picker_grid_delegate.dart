import 'package:flutter/rendering.dart';

class PickerGridDelegate extends SliverGridDelegate {
  const PickerGridDelegate({
    required this.columnCount,
    required this.rowExtent,
    required this.rowStride,
    this.columnPadding = 0,
  });

  final int columnCount;
  final double columnPadding;

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
      childMainAxisExtent: rowExtent - columnPadding,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: rowStride,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerGridDelegate oldDelegate) => false;
}
