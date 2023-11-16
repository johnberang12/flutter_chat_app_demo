import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/stacked_item.dart';

import 'custom_image.dart';

class ImageTile<T> extends StatefulWidget {
  const ImageTile(
      {super.key,
      required this.image,
      this.deleteBuilder,
      this.imageBuilder,
      this.verticalPadding,
      required this.onDelete,
      this.imageHeight,
      this.aspectRatio,
      this.imageWidth});
  final T image;

  final Widget Function(BuildContext, T)? deleteBuilder;
  final Widget Function(BuildContext, T)? imageBuilder;
  final VoidCallback onDelete;
  final double? aspectRatio;

  final double? verticalPadding, imageHeight, imageWidth;

  @override
  State<ImageTile<T>> createState() => _ImageTileState<T>();
}

class _ImageTileState<T> extends State<ImageTile<T>> {
  T? _selectedImage;

  @override
  Widget build(BuildContext context) {
    const imageSize = 50.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (widget.image == _selectedImage) {
              _selectedImage = null;
            } else {
              _selectedImage = widget.image;
            }
          });
        },
        child: StackedItem(
          top: -10,
          right: -05,
          alignment: Alignment.topRight,
          clip: Clip.none,
          inner: widget.imageBuilder != null
              ? widget.imageBuilder!(context, widget.image)
              : AspectRatio(
                  aspectRatio: widget.aspectRatio ?? 4 / 4.5,
                  child: CustomImage(
                    widget.image,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    height: widget.imageHeight ?? imageSize,
                    width: widget.imageWidth ?? imageSize * .85,
                    fit: BoxFit.cover,
                  ),
                ),
          showOuter: _selectedImage != null && widget.image == _selectedImage,
          outer: InkWell(
            onTap: widget.onDelete,
            child: widget.deleteBuilder != null
                ? widget.deleteBuilder!(context, widget.image)
                : _defaultDelete(),
          ),
        ),
      ),
    );
  }

  Widget _defaultDelete() => const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.black45,
        child: Icon(
          Icons.close,
          size: 18,
          color: Colors.white,
        ),
      );
}
