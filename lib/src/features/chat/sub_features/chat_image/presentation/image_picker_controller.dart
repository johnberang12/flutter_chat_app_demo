import 'dart:io';

import 'package:flutter_chat_app/src/features/image_picker/application/app_image_picker_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../image_picker/presentation/image_editing_controller.dart';

class ImagePickerController extends StateNotifier<AsyncValue<void>> {
  ImagePickerController({required this.service}) : super(const AsyncData(null));
  final AppImagePickerService service;

  Future<void> pickeCameraImage(
      {required ImageEditingController<File> controller}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() =>
        service.pickeCameraImage(controller: controller, allowMultiple: true));

    if (mounted) {
      state = newState;
    }
  }

  Future<void> pickGalleryImage(
      {required ImageEditingController<File> controller}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() =>
        service.pickGalleryImage(controller: controller, allowMultiple: true));
    if (mounted) {
      state = newState;
    }
  }
}

final imagePickerControllerProvider =
    StateNotifierProvider.autoDispose<ImagePickerController, AsyncValue<void>>(
        (ref) => ImagePickerController(
            service: ref.watch(appImagePickerServiceProvider)));
