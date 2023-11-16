import 'dart:io';
import 'package:flutter/material.dart';

import 'network_image.dart';

class CustomImage<T> extends StatelessWidget {
  const CustomImage(this.source,
      {super.key,
      this.borderRadius,
      this.padding,
      this.height,
      this.width,
      this.fit});
  final T source;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: _image(context)),
    );
  }

  Widget _image(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWith = MediaQuery.sizeOf(context).width;
    final imageHeight = height ?? screenHeight;
    final imageWidth = width ?? screenWith;

    if (source is File) {
      return Image(
        image: FileImage(source as File),
        height: imageHeight,
        width: imageWidth,
        fit: fit,
      );
    } else if (source is String) {
      final stringSource = source as String;
      final isValid =
          stringSource.startsWith('http') || stringSource.startsWith('https');
      if (isValid) {
        return ImageNetwork(
          imageUrl: source as String,
          height: imageHeight,
          width: imageWidth,
          fit: fit,
        );
      } else {
        return Image(
          image: AssetImage(source as String),
          height: imageHeight,
          width: imageWidth,
          fit: fit,
        );
      }
    } else {
      // Return an error icon or a placeholder image for unrecognized sources
      return const Icon(Icons.error, color: Colors.red, size: 50.0);
      // Alternatively:
      // return Image.asset('assets/placeholder.png');
    }
  }
}
