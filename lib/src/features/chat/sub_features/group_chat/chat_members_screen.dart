import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/users/common_widget/users_fetch_widget.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/chat_room.dart';

class ChatMembersScreen extends ConsumerWidget {
  const ChatMembersScreen({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersValue = ref.watch(chatMembersFutureProvider(chatRoom.memberIds));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: UsersFetchWidget(usersValue: usersValue),
    );
  }
}
