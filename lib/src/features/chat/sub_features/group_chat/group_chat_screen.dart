// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:async_widget/async_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/group_chat/group_chat_menu_button.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/application/read_chats_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_chat_app/src/common_widgets/async_value_when.dart';
import 'package:flutter_chat_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/chat/application/chat_room_service.dart';
import 'package:flutter_chat_app/src/features/chat/domain/chat.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chat_base_screen.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../users/application/app_user_service.dart';
import '../../../users/common_widget/users_fetch_widget.dart';
import '../../../users/domain/app_user.dart';
import '../../application/chat_service.dart';
import '../../application/group_chat_room_service.dart';
import '../../data/chat_repository.dart';
import '../../domain/chat_room.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  const GroupChatScreen({super.key, required this.chatRoomId});
  final ChatRoomID chatRoomId;

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen>
    with AutomaticKeepAliveClientMixin<GroupChatScreen> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return const SizedBox();

    final chatRoomValue = ref.watch(chatRoomStreamProvider(widget.chatRoomId));

    final user = ref.watch(authRepositoryProvider).currentUser;

    final chatsQuery = ref.watch(chatsQueryProvider(widget.chatRoomId));
    return AsyncValueWhen<ChatRoom?>(
        value: chatRoomValue,
        data: (chatRoom) {
          if (chatRoom == null) {
            return const ErrorMessageWidget(
                errorMessage: 'Internal Error occured.');
          }

          return AsyncWidget<({String message, List<File> images})>(
            listener: (_, next) => next.showAlertDialogOnError(context),
            identifier: idFromCurrentDate(),
            callback: (param) async {
              if (param != null && user != null) {
                await ref.read(chatServiceProvider).sendGroupMessage(
                    chatRoom, _createChat(param.message, user), param.images);
              }
            },
            child: (state, execute) {
              return ChatBaseScreen(
                updateChatRead: (chatId) => ref
                    .read(readChatsServiceProvider)
                    .updateLastReadChat(widget.chatRoomId, chatId),
                chatRoom: chatRoom,
                query: chatsQuery,
                isLoading: false,
                sendChat: (message, images) =>
                    execute((message: message, images: images)),
                exitChatRoom: (chatRoom) {},
                appBarTitle: Text(chatRoom.chatRoomTitle),
                appBarActions: [
                  GroupChatPopupMenu(chatRoom: chatRoom, userId: user?.uid)
                ],
              );
            },
          );
        });
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

class AppUserList extends HookConsumerWidget {
  ///used for searching users and adding as a group chat member
  const AppUserList({super.key, required this.chatRoom});
  final ChatRoom chatRoom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersValue = ref.watch(appUsersStreamProvider);

    return Container(
      decoration: BoxDecoration(
          color: AppColors.containerColor(context),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AsyncWidget<AppUser>(
          listener: (_, next) => next.showAlertDialogOnError(context),
          callback: (user) async {
            if (user != null) {
              await ref
                  .read(groupChatRoomServiceProvider)
                  .addChatRoomMember(chatRoom, user)
                  .then((value) => context.pop());
            }
          },
          identifier: idFromCurrentDate(),
          child: (state, execute) => UsersFetchWidget(
            usersValue: usersValue,
            onTap: execute,
            isLoading: state.isLoading,
            separator: gapH4,
          ),
        ),
      ),
    );
  }
}
