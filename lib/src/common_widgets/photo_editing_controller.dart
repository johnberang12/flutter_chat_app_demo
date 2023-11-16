import 'dart:io';

import 'package:flutter/material.dart';

import '../features/image/presentation/image_tile.dart';

class PhotoEditingController extends ValueNotifier<List<dynamic>> {
  PhotoEditingController() : super([]);

  void add(dynamic imageSource) {
    value = [...value, imageSource];
  }

  void addAll(List<dynamic> imageSources) {
    value = [...value, ...imageSources];
  }

  void remove(dynamic imageSource) {
    value = List.from(value)..remove(imageSource);
  }

  dynamic removeAt(int index) {
    if (index >= 0 && index < value.length) {
      var removedItem = value[index];
      value = List.from(value)..removeAt(index);
      return removedItem;
    }
    return null; // or throw an exception based on your requirements
  }

  void insert(int index, dynamic imageSource) {
    if (index >= 0 && index <= value.length) {
      value = List.from(value)..insert(index, imageSource);
    }
  }

  void replace(imageSource) {
    value = [imageSource];
  }

  void clear() {
    value = [];
  }

  List<File> get fileImages {
    return value.whereType<File>().cast<File>().toList();
  }

  List<String> get networkImages {
    return value
        .where((image) =>
            image is String &&
            ((image).startsWith('http') || (image).startsWith('https')))
        .cast<String>()
        .toList();
  }

  List<String> get assetImages {
    return value
        .where((image) => image is String && (image).startsWith('assets/'))
        .cast<String>()
        .toList();
  }
}

class PhotoInputField extends StatelessWidget {
  const PhotoInputField(
      {super.key, required this.controller, this.imageBuilder, this.height});
  final PhotoEditingController controller;
  final Widget Function()? imageBuilder;
  final double? height;

  @override
  Widget build(BuildContext context) {
    const defaultHeight = 90.0;
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, images, _) => images.isEmpty
          ? const SizedBox()
          : SizedBox(
              height: height ?? defaultHeight,
              child: images.length == 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageTile(
                          imageHeight: height ?? defaultHeight,
                          onDelete: () => controller.clear(),
                          image: images.first,
                        ),
                      ],
                    )
                  : ReorderableListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      onReorder: _reorder,
                      children: [
                          for (var image in images)
                            ImageTile(
                                key: ValueKey(image),
                                image: image,
                                imageHeight: height ?? defaultHeight,
                                onDelete: () => controller.remove(image))
                        ]),
            ),
    );
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = controller.removeAt(oldIndex);
    controller.insert(newIndex, item);
  }
}
