import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/presentation/indicator_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../authentication/data/auth_repository.dart';
import '../../../domain/chat_room.dart';

class ChatRoomScreenTypingIndicator extends ConsumerWidget {
  const ChatRoomScreenTypingIndicator(
      {super.key, required this.chatRoom, required this.child});
  final Widget child;
  final ChatRoom? chatRoom;

  bool isTyping(WidgetRef ref) {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    final peerId = chatRoom?.memberIds.firstWhere((id) => id != userId);
    if (userId == null || peerId == null) return false;
    final peerData = chatRoom?.members.members[peerId];
    if (peerData == null) return false;
    return peerData.isTyping;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: child),
        if (isTyping(ref)) ...[
          const TypingIndicatorWidget(padding: EdgeInsets.only(left: 35)),
        ]
      ],
    );
  }
}
