import 'package:flutter/widgets.dart';

import 'app_loader.dart';

class WidgetLoader extends StatelessWidget {
  const WidgetLoader({
    super.key,
    required this.child,
    this.isLoading = false,
    this.alignment = Alignment.center,
  });
  final bool isLoading;
  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        Opacity(opacity: isLoading ? 0.5 : 1.0, child: child),
        if (isLoading) ...[AppLoader.circularProgress()]
      ],
    );
  }
}
