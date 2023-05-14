import 'package:flutter/rendering.dart';

class PickerGridDelegate extends SliverGridDelegate {
  final int columnCount;
  final double columnPadding;
  final double rowHeight;
  const PickerGridDelegate(
      {required this.columnCount,
      required this.rowHeight,
      this.columnPadding = 0});

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = constraints.crossAxisExtent / columnCount;

    return SliverGridRegularTileLayout(
      // to add padding between cells.
      childCrossAxisExtent: tileWidth - columnPadding,
      childMainAxisExtent: rowHeight - columnPadding,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: rowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(PickerGridDelegate oldDelegate) => false;
}
