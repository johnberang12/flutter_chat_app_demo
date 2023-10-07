// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_chat_app/src/features/image_picker/presentation/image_editing_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../data/app_image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_image_picker_service.g.dart';

class AppImagePickerService {
  AppImagePickerService({required this.picker});
  final AppImagePicker picker;

  Future<void> pickeCameraImage({
    required ImageEditingController<File> controller,
    required bool allowMultiple,
  }) async {
    final image = await picker.pickeImage(source: ImageSource.camera);
    if (image == null) return;
    if (allowMultiple) {
      controller.addItem(image);
    } else {
      controller.replace(image);
    }
  }

  Future<void> pickGalleryImage({
    required ImageEditingController<File> controller,
    required bool allowMultiple,
  }) async {
    if (allowMultiple) {
      final images = await picker.pickMultiImage();
      if (images.isEmpty) return;
      controller.addAll(images);
    } else {
      final image = await picker.pickeImage(source: ImageSource.gallery);
      if (image == null) return;
      controller.replace(image);
    }
  }
}

@Riverpod(keepAlive: true)
AppImagePickerService appImagePickerService(AppImagePickerServiceRef ref) =>
    AppImagePickerService(picker: ref.watch(appImagePickerProvider));
