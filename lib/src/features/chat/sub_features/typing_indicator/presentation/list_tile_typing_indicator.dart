import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/presentation/indicator_widget.dart';

import '../../../domain/chat_room.dart';

class ListTileTypingIndicator extends StatelessWidget {
  const ListTileTypingIndicator(
      {super.key, required this.room, required this.child});
  final ChatRoom room;
  final Widget child;

  bool isTyping() {
    return room.members.members.values.any((member) => member.isTyping);
  }

  @override
  Widget build(BuildContext context) {
    return isTyping()
        ? const TypingIndicatorWidget(isGroup: false, size: 35)
        : child;
  }
}
