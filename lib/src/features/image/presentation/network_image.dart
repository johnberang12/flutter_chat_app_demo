import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../shimmer/shimmer_widget.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork(
      {super.key,
      required this.imageUrl,
      required this.height,
      required this.width,
      this.borderRadius = 0.0,
      this.fit,
      this.emptyFillColor});
  final String imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final BoxFit? fit;
  final Color? emptyFillColor;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: ((context, url) =>
          ShimmerWidget.reactangular(height: height, width: width)),
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
      errorWidget: ((context, url, error) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: emptyFillColor ?? AppColors.black20(context),
            ),
            height: height,
            child: const Center(
                child: Text(
              'Something went wrong',
              textAlign: TextAlign.center,
            )),
          )),
    );
  }
}
