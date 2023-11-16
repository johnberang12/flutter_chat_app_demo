import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/image/presentation/image_tile.dart';
import 'package:flutter_chat_app/src/features/image_picker/presentation/image_editing_controller.dart';

class ImageInputField extends StatelessWidget {
  const ImageInputField(
      {super.key, required this.controller, required this.images});
  final ImageEditingController controller;
  final List<dynamic> images;
  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = controller.removeAt(oldIndex);
    controller.insert(newIndex, item);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: controller.length == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageTile(
                  onDelete: () => controller.clear(),
                  image: controller.value.first,
                ),
              ],
            )
          : ReorderableListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onReorder: _reorder,
              children: [
                  for (var image in controller.value)
                    ImageTile(
                        key: ValueKey(image),
                        image: image,
                        onDelete: () => controller.removeItem(image))
                ]),
    );
  }
}
