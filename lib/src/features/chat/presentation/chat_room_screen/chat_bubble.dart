import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/app_colors.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../users/domain/app_user.dart';
import '../../domain/chat.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IsMeWidget(
      senderId: chat.senderId,
      child: (color) => Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(chat.message),
          )),
    );
  }
}

class IsMeWidget extends ConsumerWidget {
  const IsMeWidget({super.key, required this.senderId, required this.child});
  final UserID senderId;
  final Widget Function(Color) child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final isMe = userId == senderId;
    final cardColor = isMe ? Colors.amber : AppColors.grey300;
    return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: child(cardColor));
  }
}
