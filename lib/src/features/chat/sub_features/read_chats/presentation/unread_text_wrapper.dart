import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/presentation/list_tile_typing_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../constants/styles.dart';
import '../../../../authentication/data/auth_repository.dart';
import '../../../domain/chat_room.dart';

class LastMessageText extends ConsumerWidget {
  const LastMessageText({super.key, required this.chatRoom});
  final ChatRoom chatRoom;
  // final RoomActivity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = chatRoom.activity;
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final senderIsMe = userId == activity.senderId;
    final senderName = senderIsMe ? 'You' : activity.senderName;
    final message = activity.lastMessage;
    return ListTileTypingIndicator(
      room: chatRoom,
      child: message.isNotEmpty
          ? Text(
              '$senderName: $message',
              style: !senderIsMe && !activity.read.contains(userId)
                  ? Styles.k16Bold(context).copyWith(color: Colors.blue)
                  : null,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          : const SizedBox.shrink(),
    );
  }
}
