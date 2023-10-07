import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/domain/chat_member.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/presentation/indicator_widget.dart';

class ListTileTypingIndicator extends StatelessWidget {
  const ListTileTypingIndicator(
      {super.key, required this.peerData, required this.child});
  final ChatMemberData? peerData;
  final Widget child;

  bool isTyping() {
    return peerData?.isTyping ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return isTyping() ? const TypingIndicatorWidget(size: 35) : child;
  }
}
