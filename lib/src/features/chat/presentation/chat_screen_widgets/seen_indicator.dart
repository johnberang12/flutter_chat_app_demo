import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widgets/user_avatar.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';

class SeenIndicator extends ConsumerWidget {
  const SeenIndicator(
      {super.key,
      required this.chatRoom,
      required this.chat,
      required this.child});
  final ChatRoom chatRoom;

  final Chat chat;

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final members = chatRoom.members
        .toRoomMemberList()
        .where((member) => member.uid != userId && member.uid != chat.senderId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        child,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (var member in members)
              if (member.lastReadChat == chat.id)
                UserAvatar(photoUrl: member.imageUrl, radius: 7)
          ],
        )
      ],
    );
  }
}
