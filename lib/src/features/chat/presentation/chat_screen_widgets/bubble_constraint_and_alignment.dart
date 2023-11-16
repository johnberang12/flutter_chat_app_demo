import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../authentication/data/auth_repository.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';

class BubbleConstraintAndAlignemnt extends ConsumerWidget {
  const BubbleConstraintAndAlignemnt(
      {super.key,
      required this.chatRoom,
      required this.chat,
      required this.child});
  final ChatRoom chatRoom;
  final Chat chat;
  final Widget Function(bool) child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final isMe = chat.senderId == userId;
    final maxWidth = MediaQuery.sizeOf(context).width * .85;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          // width: maxWidth,
          child: child(isMe)),
    );
  }
}
