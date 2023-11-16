import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'custom_shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.reactangular(
      {super.key, required this.height, required this.width})
      : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular(
      {super.key,
      required this.height,
      required this.width,
      this.shapeBorder = const CircleBorder()});
  final ShapeBorder shapeBorder;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    // final brightness = Theme.of(context).brightness;
    return CustomShimmer(
      // baseColor: Colors.grey[300]!,
      // highlightColor: Colors.grey[100]!,
      // period: const Duration(milliseconds: 1000),
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: AppColors.black20(context),
        ),
      ),
    );
  }
}
