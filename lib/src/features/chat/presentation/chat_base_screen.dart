import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/collection_query_builder.dart';
import 'package:flutter_chat_app/src/common_widgets/widget_life_cycle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/center_text.dart';
import '../../../common_widgets/list_listener.dart';
import '../../../constants/sizes.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
import '../sub_features/typing_indicator/presentation/chat_keyboard_listener_widget.dart';
import '../sub_features/typing_indicator/presentation/chat_room_screen_typing_indicator.dart';
import 'chat_room_screen/chat_bubble.dart';
import 'chat_screen_widgets/bubble_constraint_and_alignment.dart';
import 'chat_screen_widgets/chat_bubble_sender_avatar.dart';
import 'chat_screen_widgets/seen_indicator.dart';
import 'chat_text_field/chat_text_field.dart';

class ChatBaseScreen extends StatelessWidget {
  const ChatBaseScreen(
      {super.key,
      required this.chatRoom,
      required this.query,
      required this.isLoading,
      required this.sendChat,
      this.appBarTitle,
      this.appBarActions,
      required this.exitChatRoom,
      required this.updateChatRead});

  final ChatRoom? chatRoom;
  final Query<Chat> query;
  final bool isLoading;
  final Future<void> Function(String, List<File>) sendChat;
  final Widget? appBarTitle;
  final List<Widget>? appBarActions;
  final void Function(ChatRoom) exitChatRoom;
  final void Function(ChatRoomID) updateChatRead;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appBarTitle, actions: appBarActions),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ChatRoomScreenBody(
          query: query,
          isLoading: isLoading,
          chatRoom: chatRoom,
          exitChatRoom: exitChatRoom,
          updateChatRead: updateChatRead,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatTextField(
          sendChat: sendChat,
        ),
      ),
    );
  }
}

class ChatRoomScreenBody extends StatelessWidget {
  const ChatRoomScreenBody(
      {super.key,
      required this.query,
      required this.isLoading,
      required this.chatRoom,
      required this.exitChatRoom,
      required this.updateChatRead});

  final Query<Chat> query;
  final bool isLoading;
  final ChatRoom? chatRoom;
  final void Function(ChatRoom) exitChatRoom;
  final void Function(ChatRoomID) updateChatRead;

  @override
  Widget build(BuildContext context) {
    //

    return ChatListFetcherWidget(
        query: query,
        childBuilder: (chats, snapshot) {
          return switch ((chatRoom, chats)) {
            ((null, _) || (_, [])) =>
              const CenterText(text: 'Be the first to say Hi!'),
            (_, _) => WidgetLifecyle(
                inactive: () => exitChatRoom(chatRoom!),
                child: ChatRoomScreenTypingIndicator(
                  chatRoom: chatRoom!,
                  child: ChatKeyboardListenerWidget(
                    chatRoom: chatRoom!,
                    child: ListListener(
                      chats: chats,
                      callback: () => updateChatRead(chats.first.id),
                      child: ChatListView(
                        chats: chats,
                        snapshot: snapshot,
                        itemBuilder: (chat) => SeenIndicator(
                          chatRoom: chatRoom!,
                          chat: chat,
                          // lastChat: chats.last,
                          child: BubbleConstraintAndAlignemnt(
                            chatRoom: chatRoom!,
                            chat: chat,
                            child: (isMe) => ChatBubbleSenderAvatar(
                                chatRoom: chatRoom!,
                                chatSenderId: chat.senderId,
                                isMe: isMe,
                                child: ChatBubble(chat: chat, isMe: isMe)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          };
        });
  }
}

class ChatListFetcherWidget extends HookConsumerWidget {
  const ChatListFetcherWidget(
      {super.key, required this.query, required this.childBuilder});
  final Query<Chat> query;
  final Widget Function(List<Chat>, FirestoreQueryBuilderSnapshot<Chat>)
      childBuilder;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CollectionQueryBuilder<Chat>(
        query: query,
        builder: (context, snapshot) {
          final chats =
              snapshot.docs.map((e) => e.data()).whereType<Chat>().toList();

          return childBuilder(chats, snapshot);
        });
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView(
      {super.key,
      required this.chats,
      required this.snapshot,
      required this.itemBuilder});

  final List<Chat> chats;
  final FirestoreQueryBuilderSnapshot<Chat> snapshot;
  final Widget Function(Chat) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: chats.length,
        separatorBuilder: (context, index) => gapH8,
        itemBuilder: (context, index) {
          //* fetch more chats
          if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
            snapshot.fetchMore();
          }
          final chat = chats[index];
          return itemBuilder(chat);
        });
  }
}
