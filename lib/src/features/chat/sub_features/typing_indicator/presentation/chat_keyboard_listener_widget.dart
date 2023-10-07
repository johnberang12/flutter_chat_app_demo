import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/application/typing_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/chat_room.dart';
import 'keyboard_stream_listener.dart';

class ChatKeyboardListenerWidget extends ConsumerWidget {
  const ChatKeyboardListenerWidget(
      {super.key, required this.chatRoom, required this.child});
  final ChatRoom? chatRoom;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
        keyboardListenerProvider((isVisible) =>
            ref.read(typingServiceProvider).toggleTyping(chatRoom, isVisible)),
        (previous, next) {});
    return child;
  }
}
