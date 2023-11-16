import 'package:flutter/material.dart';

import '../../../users/domain/app_user.dart';
import '../../domain/chat_room.dart';

class ChatBubbleSenderAvatar extends StatelessWidget {
  const ChatBubbleSenderAvatar(
      {super.key,
      required this.chatRoom,
      required this.child,
      required this.chatSenderId,
      required this.isMe});
  final UserID chatSenderId;
  final ChatRoom chatRoom;
  final Widget child;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final String? url = chatRoom.members.members[chatSenderId]?.imageUrl;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe) ...[
          CircleAvatar(
            radius: 12,
            backgroundImage: url == null ? null : NetworkImage(url),
            child: url == null ? const Icon(Icons.person) : null,
          )
        ],
        Expanded(child: child)
      ],
    );
  }
}
