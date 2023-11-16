import 'package:flutter/material.dart';

class StackedItem extends StatelessWidget {
  const StackedItem(
      {super.key,
      required this.inner,
      required this.outer,
      this.showOuter = true,
      this.left,
      this.top,
      this.right,
      this.bottom,
      this.height,
      this.width,
      this.alignment = AlignmentDirectional.topStart,
      this.fit = StackFit.loose,
      this.clip = Clip.hardEdge});
  final Widget inner, outer;
  final bool showOuter;
  final double? left, top, right, bottom, width, height;
  final AlignmentGeometry alignment;
  final StackFit fit;
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clip,
      children: [
        inner,
        if (showOuter) ...[
          Positioned(
              left: left,
              top: top,
              right: right,
              bottom: bottom,
              width: width,
              height: height,
              child: outer)
        ]
      ],
    );
  }
}
