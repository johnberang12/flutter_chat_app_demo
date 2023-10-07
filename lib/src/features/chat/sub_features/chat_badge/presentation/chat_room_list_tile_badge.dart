import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/chat_badge/presentation/chat_badge.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../authentication/data/auth_repository.dart';
import '../../../domain/chat_room.dart';

class ChatRoomListTileBadge extends ConsumerWidget {
  const ChatRoomListTileBadge(
      {super.key, required this.room, required this.child});
  final ChatRoom room;
  final Widget child;
  int badgeCount(WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final myData = room.members.members[userId];
    return myData?.badgeCount ?? 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        child,
        if (badgeCount(ref) > 0) ...[ChatBadge(badgeCount: badgeCount(ref))]
      ],
    );
  }
}
