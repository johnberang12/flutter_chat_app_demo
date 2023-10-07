import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class GridLayout extends StatelessWidget {
  const GridLayout(
      {super.key,
      this.minRows,
      required this.itemCount,
      required this.itemBuilder,
      this.rowGap = 10,
      this.columnGap = 10,
      this.gridFit = GridFit.loose});

  /// Total number of items to display.
  final int? itemCount;

  ///number of rows to display
  final int? minRows;

  /// Function used to build a widget for a given index in the grid.
  final Widget Function(BuildContext, int) itemBuilder;

  ///rows and columns spacing
  final double rowGap;
  final double columnGap;
  final GridFit gridFit;

  @override
  Widget build(BuildContext context) {
    // use a LayoutBuilder to determine the crossAxisCount
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      // 2 column for width < 500px
      // then add one more column for each 250px
      final crossAxisCount = max(minRows ?? 2, width ~/ 250);
      // once the crossAxisCount is known, calculate the column and row sizes
      // set some flexible track sizes based on the crossAxisCount with 1.fr
      final columnSizes = List.generate(crossAxisCount, (_) => 1.fr);
      final numRows = (itemCount! / crossAxisCount).ceil();
      // set all the row sizes to auto (self-sizing height)
      final rowSizes = List.generate(numRows, (_) => auto);
      // Custom layout grid. See: https://pub.dev/packages/flutter_layout_grid
      return LayoutGrid(
        gridFit: gridFit,
        columnSizes: columnSizes,
        rowSizes: rowSizes,
        rowGap: rowGap, // equivalent to mainAxisSpacing
        columnGap: columnGap, // equivalent to crossAxisSpacing
        children: [
          // render all the items with automatic child placement
          for (var i = 0; i < itemCount!; i++) itemBuilder(context, i),
        ],
      );
    });
  }
}
