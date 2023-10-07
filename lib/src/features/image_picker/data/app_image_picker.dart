// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_image_picker.g.dart';

class AppImagePicker {
  AppImagePicker({required ImagePicker picker}) : _picker = picker;
  final ImagePicker _picker;
  Future<File?> pickeImage(
      {required ImageSource source,
      double? maxHeight,
      double? maxWidth,
      int? imageQuality}) async {
    final image = await _picker.pickImage(
        source: source,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality);

    ///return the file if the image is not null
    return image == null ? null : File(image.path);
  }

  Future<List<File>> pickMultiImage(
      {double? maxHeight, double? maxWidth, int? imageQuality}) async {
    final images = await _picker.pickMultiImage(
        maxHeight: maxHeight, maxWidth: maxWidth, imageQuality: imageQuality);
    final List<File> files = [];
    if (images.isEmpty) return files;
    for (var image in images) {
      final file = File(image.path);
      files.add(file);
    }
    return files;
  }
}

@Riverpod(keepAlive: true)
ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@Riverpod(keepAlive: true)
AppImagePicker appImagePicker(AppImagePickerRef ref) =>
    AppImagePicker(picker: ref.watch(imagePickerProvider));
