import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/chat_image/presentation/image_picker_controller.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../image_picker/presentation/image_editing_controller.dart';

enum PickSource { gallery, camera }

class ImagePickerButton extends ConsumerWidget {
  const ImagePickerButton({
    super.key,
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

  Future<void> _pickGalleryImage(
      WidgetRef ref, ImageEditingController<File> controller) async {
    await ref
        .read(imagePickerControllerProvider.notifier)
        .pickGalleryImage(controller: controller);
  }

  Future<void> _pickCameraImage(
      WidgetRef ref, ImageEditingController<File> controller) async {
    await ref
        .read(imagePickerControllerProvider.notifier)
        .pickeCameraImage(controller: controller);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(imagePickerControllerProvider,
        (previous, next) => next.showAlertDialogOnError(context));

    final controller = ref.watch(imageEditingControllerProvider.notifier);
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: InkWell(
          onTap: onPressed ?? () => _pickImage(ref, controller),
          child: Icon(icon, size: iconSize)),
    );
  }

  void _pickImage(WidgetRef ref, ImageEditingController<File> controller) {
    switch (source) {
      case PickSource.gallery:
        _pickGalleryImage(ref, controller);
        break;
      case PickSource.camera:
        _pickCameraImage(ref, controller);
        break;
      default:
        return;
    }
  }
}
