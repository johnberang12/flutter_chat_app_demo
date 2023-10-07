import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/widget_loader.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/presentation/read_chats_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/chat_room.dart';

class ReadChatsControllerListener extends ConsumerWidget {
  const ReadChatsControllerListener(
      {super.key, required this.chatRoom, required this.child});
  final Widget child;
  final ChatRoom? chatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(readChatsControllerProvider(chatRoom), (previous, next) {});
    // final state = ref.watch(readChatsControllerProvider(chatRoom));
    return WidgetLoader(isLoading: false, child: child);
  }
}
