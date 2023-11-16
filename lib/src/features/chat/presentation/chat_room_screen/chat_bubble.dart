import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/app_colors.dart';
import '../../domain/chat.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({super.key, required this.chat, required this.isMe});
  final Chat chat;
  final bool isMe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardColor = isMe ? Colors.amber : AppColors.grey300;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chat.message.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(chat.message),
                  )
                ],
                if (chat.photos.isNotEmpty) ...[
                  ImageDisplay(photos: chat.photos)
                ]
              ],
            ),
          )),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key, required this.photos});
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Horizontal space between items
            mainAxisSpacing: 4.0), // Vertical space between items),
        itemBuilder: (context, index) {
          return CachedNetworkImage(imageUrl: photos[index], fit: BoxFit.cover);
        });
  }
}
