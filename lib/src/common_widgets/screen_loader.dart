import 'package:flutter/widgets.dart';

import 'app_loader.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key, required this.isLoading, required this.child});
  final Widget child;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.5 : 1.0,
          child: child,
        ),
        isLoading ? AppLoader.circularProgress() : const SizedBox()
      ],
    );
  }
}
