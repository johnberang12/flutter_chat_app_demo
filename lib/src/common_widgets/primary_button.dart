import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants/app_colors.dart';
import '../constants/breakpoints.dart';
import '../constants/styles.dart';
import 'app_loader.dart';

class PrimaryButton extends HookWidget {
  const PrimaryButton({
    Key? key,
    this.child,
    this.height,
    this.width,
    this.onPressed,
    this.padding,
    this.loadingDuration = 1500,
    this.buttonTitle = 'Submit',
    this.showLoading = true,
    this.titleFontSize,
    this.backgroundColor,
    this.loading = false,
  }) : super(key: key);
  final Widget? child;
  final double? height;
  final double? width;
  final FutureOr<void> Function()? onPressed;

  final Color? backgroundColor;
  final String buttonTitle;
  final bool showLoading;

  final EdgeInsetsGeometry? padding;
  final int loadingDuration;
  final double? titleFontSize;
  final bool loading;

//* this is used to show loading spinner while the button is performning a task.
//* it is also used to disable the button to prevent user from interacting with it while operation is in progress
  void _handleButtonPress(
      ValueNotifier<bool> isLoading, IsMounted isMounted) async {
    if (onPressed != null) {
      isLoading.value = true;
      // print('isLoading: ${isLoading.value}');
      await onPressed!();
      final mounted = isMounted();
      // print('mounted: $mounted');
      if (mounted) {
        isLoading.value = false;
        // print('isLoading: ${isLoading.value}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final isLoading = useState<bool>(false);
    final screenWidth = MediaQuery.of(context).size.width;
    final double defaultWidth =
        screenWidth < Breakpoint.tablet ? screenWidth : 550;
    return SizedBox(
      height: height ?? 57,
      width: width ?? defaultWidth,
      child: MaterialButton(
        disabledColor: AppColors.black50(context),
        onPressed: isLoading.value || loading || onPressed == null
            ? null
            : () => _handleButtonPress(isLoading, isMounted),
        color: backgroundColor ?? AppColors.primaryHue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: isLoading.value || loading
            ? AppLoader.circularProgress(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: AppColors.blues,
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: child ??
                    Text(buttonTitle,
                        style: Styles.k18Bold(context).copyWith(
                            color: Colors.white, fontSize: titleFontSize))),
      ),
    );
  }
}
