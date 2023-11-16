import 'dart:io';

import 'package:async_widget/async_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/chat/application/chat_service.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chat_base_screen.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/application/read_chats_service.dart';

import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../users/domain/app_user.dart';
import '../../application/chat_room_service.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen(
      {super.key, required this.chatRoomId, required this.peerUser});
  final ChatRoomID chatRoomId;
  final AppUser peerUser;

  @override
  ConsumerState<ChatScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
  @override
  bool get wantKeepAlive => true;
  Future<void> sendChat(String message, List<File> images) async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final chatRoom = ref.watch(chatRoomStreamProvider(widget.chatRoomId)).value;
    final user = ref.watch(authRepositoryProvider).currentUser;

    final chatsQuery = ref.watch(chatsQueryProvider(widget.chatRoomId));

    return AsyncWidget<({String message, List<File> images})>(
      listener: (_, next) => next.showAlertDialogOnError(context),
      callback: (param) async {
        if (param != null && user != null) {
          await ref.read(chatServiceProvider).sendChat(
              chatRoom: chatRoom,
              peerUser: widget.peerUser,
              chat: _createChat(param.message, user),
              files: param.images);
        }
      },
      identifier: idFromCurrentDate(),
      child: (state, execute) => ChatBaseScreen(
        updateChatRead: (chatId) => ref
            .read(readChatsServiceProvider)
            .updateLastReadChat(widget.chatRoomId, chatId),
        chatRoom: chatRoom,
        query: chatsQuery,
        isLoading: state.isLoading,
        sendChat: (message, images) =>
            execute((message: message, images: images)),
        exitChatRoom: (chatRoom) =>
            ref.read(chatRoomServiceProvider).exitChatRoom(chatRoom),
        appBarTitle: Text(chatRoom != null && chatRoom.isGroup
            ? chatRoom.chatRoomTitle
            : chatRoom != null && !chatRoom.isGroup
                ? widget.peerUser.name
                : ''),
        appBarActions: const [],
      ),
    );
  }

  Chat _createChat(String message, User user) {
    final id = idFromCurrentDate();
    return Chat(
        id: id,
        message: message,
        photos: [],
        senderId: user.uid,
        senderName: user.displayName ?? '');
  }
}
