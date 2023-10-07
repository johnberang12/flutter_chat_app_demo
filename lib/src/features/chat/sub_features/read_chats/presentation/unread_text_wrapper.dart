import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../constants/styles.dart';
import '../../../../authentication/data/auth_repository.dart';
import '../../../domain/room_activity.dart';

class UnreadTextWrapper extends ConsumerWidget {
  const UnreadTextWrapper({super.key, required this.activity});
  final RoomActivity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final senderIsMe = userId == activity.senderId;
    return Text(
      activity.lastMessage,
      style: !senderIsMe && !activity.read
          ? Styles.k18Bold(context).copyWith(color: Colors.blue)
          : null,
      overflow: TextOverflow.ellipsis,
    );
  }
}
