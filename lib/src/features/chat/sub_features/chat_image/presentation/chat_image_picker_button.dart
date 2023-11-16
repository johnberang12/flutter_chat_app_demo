import 'package:async_widget/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_chat_app/src/features/image_picker/application/app_image_picker_service.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../common_widgets/photo_editing_controller.dart';

enum PickSource { gallery, camera }

class ImagePickerButton extends ConsumerWidget {
  const ImagePickerButton({
    super.key,
    required this.controller,
    required this.icon,
    this.onPressed,
    this.padding,
    this.iconSize,
    this.source,
  });
  final void Function()? onPressed;
  final IconData icon;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final PickSource? source;
  final PhotoEditingController controller;

  Future<void> _pickGalleryImage(WidgetRef ref) async {
    await ref
        .read(appImagePickerServiceProvider)
        .pickGalleryImage(controller: controller, allowMultiple: true);
  }

  Future<void> _pickCameraImage(WidgetRef ref) async {
    await ref
        .read(appImagePickerServiceProvider)
        .pickeCameraImage(controller: controller, allowMultiple: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: AsyncWidget<dynamic>(
        listener: (_, next) => next.showAlertDialogOnError(context),
        callback: (param) async => _pickImage(ref),
        identifier: idFromCurrentDate(),
        child: (state, execute) => InkWell(
            onTap: onPressed ?? () => execute(null),
            child: state.isLoading
                ? AppLoader.circularProgress()
                : Icon(icon, size: iconSize)),
      ),
    );
  }

  void _pickImage(WidgetRef ref) {
    switch (source) {
      case PickSource.gallery:
        _pickGalleryImage(ref);
        break;
      case PickSource.camera:
        _pickCameraImage(ref);
        break;
      default:
        return;
    }
  }
}
