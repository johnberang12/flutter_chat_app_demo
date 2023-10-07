import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/async_value_when.dart';
import 'package:flutter_chat_app/src/common_widgets/center_text.dart';
import 'package:flutter_chat_app/src/common_widgets/widget_loader.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/chat/data/chat_repository.dart';
import 'package:flutter_chat_app/src/common_widgets/widget_life_cycle.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chat_room_screen/read_chats_controller_listener.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chat_room_screen/room_screen_controller.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/presentation/chat_keyboard_listener_widget.dart';
import 'package:flutter_chat_app/src/features/chat/util/get_chat_room_id.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../users/domain/app_user.dart';
import '../../application/chat_room_service.dart';
import '../../domain/chat_room.dart';
import '../../sub_features/typing_indicator/presentation/chat_room_screen_typing_indicator.dart';
import 'chat_bubble.dart';
import '../chat_text_field/chat_text_field.dart';

class ChatRoomScreen extends HookConsumerWidget {
  const ChatRoomScreen({super.key, required this.peerUser});
  final AppUser peerUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(roomScreenControllerProvider,
        (previous, next) => next.showAlertDialogOnError(context));
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid ?? "";
    final chatRoomId = getChatRoomId(userId, peerUser.uid);
    final chatRoom = ref.watch(chatRoomStreamProvider(chatRoomId)).value;

    return WidgetLifecyle(
      inactive: () => ref.read(chatRoomServiceProvider).exitChatRoom(chatRoom),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(peerUser.name)),
        body: ChatRoomScreenBody(chatRoomId: chatRoomId, chatRoom: chatRoom),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChatKeyboardListenerWidget(
            chatRoom: chatRoom,
            child: ChatTextField(
              chatRoomId: chatRoomId,
              room: chatRoom,
              peerUser: peerUser,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomScreenBody extends ConsumerWidget {
  const ChatRoomScreenBody(
      {super.key, required this.chatRoomId, required this.chatRoom});
  final ChatRoomID chatRoomId;
  final ChatRoom? chatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsValue = ref.watch(chatsStreamProvider(chatRoomId));
    final state = ref.watch(roomScreenControllerProvider);
    return ReadChatsControllerListener(
      chatRoom: chatRoom,
      child: WidgetLoader(
          isLoading: state.isLoading,
          child: ChatRoomScreenTypingIndicator(
              chatRoom: chatRoom,
              child: AsyncValueWhen(
                  value: chatsValue,
                  data: (chats) {
                    if (chats.isEmpty) {
                      return const CenterText(text: 'Be the first to say Hi!');
                    }
                    return ListView.separated(
                        itemCount: chats.length,
                        separatorBuilder: (context, index) => gapH8,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          return ChatBubble(chat: chat);
                        });
                  }))),
    );
  }
}
