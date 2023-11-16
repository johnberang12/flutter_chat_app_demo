import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/image/presentation/custom_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key, required this.photoUrl, required this.radius, this.iconColor})
      : super(key: key);
  final Color? iconColor;
  final String photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // If there's no photo URL, show a default icon.
    if (photoUrl.isEmpty) {
      // Calculate the icon size based on the avatar radius. This can be adjusted.
      double iconSize = radius * 1.8; // This ratio can be adjusted as needed

      return CircleAvatar(
        radius: radius,
        // backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          size: iconSize, // set the icon size
          color: iconColor, // optional: set the icon color
        ), // optional: set a background color for the avatar
      );
    }

    // If there's a photo URL, display the image.
    return CircleAvatar(
      radius: radius,
      child: CustomImage(
        photoUrl,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
