import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../constants/app_colors.dart';

class TypingIndicatorWidget extends StatelessWidget {
  const TypingIndicatorWidget(
      {super.key,
      required this.isGroup,
      this.color,
      this.padding,
      this.size = 40.0,
      this.mainAxisAlignment = MainAxisAlignment.start});
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final double size;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: SpinKitThreeBounce(
            size: size,
            color: color ?? AppColors.grey600,
          ),
        ),
        if (isGroup) ...[const Text('Someone is typing...')]
      ],
    );
  }
}
