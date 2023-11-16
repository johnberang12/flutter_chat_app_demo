import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/application/typing_service.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/chat_room.dart';

class ChatKeyboardListenerWidget extends ConsumerStatefulWidget {
  const ChatKeyboardListenerWidget(
      {super.key, required this.chatRoom, required this.child});
  final ChatRoom chatRoom;
  final Widget child;

  @override
  ConsumerState<ChatKeyboardListenerWidget> createState() =>
      _ChatKeyboardListenerWidgetState();
}

class _ChatKeyboardListenerWidgetState
    extends ConsumerState<ChatKeyboardListenerWidget> {
  late StreamSubscription<bool> _subscription;

  Future<void> _updateTyping(bool isVisible) =>
      ref.read(typingServiceProvider).toggleTyping(widget.chatRoom, isVisible);

  @override
  void initState() {
    super.initState();
    _subscription =
        KeyboardVisibilityController().onChange.listen(_updateTyping);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
