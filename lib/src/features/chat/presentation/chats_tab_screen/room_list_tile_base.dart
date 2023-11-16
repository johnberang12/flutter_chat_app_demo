// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widgets/widget_loader.dart';
import '../../../../constants/styles.dart';
import '../../../app_router/app_router.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../domain/chat_room.dart';
import '../../sub_features/chat_badge/presentation/chat_room_list_tile_badge.dart';
import '../../sub_features/read_chats/presentation/unread_text_wrapper.dart';
import 'list_tile_trailing.dart';

class RoomListTileBase extends StatelessWidget {
  const RoomListTileBase({
    Key? key,
    required this.room,
    required this.isLoading,
    required this.onTap,
    required this.title,
    required this.deleteChatRoom,
    required this.undoDeletion,
  }) : super(key: key);
  final ChatRoom room;
  final bool isLoading;
  final void Function() onTap;
  final String title;
  final Future<void> Function(WidgetRef) deleteChatRoom;
  final Future<void> Function(WidgetRef) undoDeletion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: WidgetLoader(
        isLoading: isLoading,
        child: ChatRoomListTileBadge(
            room: room,
            child: ListTile(
              isThreeLine: true,
              onTap: onTap,
              // () => context.pushNamed(RoutePath.chatRoom.name),
              tileColor: Colors.amber.shade300,
              leading: CircleAvatar(
                  radius: 30,
                  child: Icon(room.isGroup ? Icons.group : Icons.person,
                      size: 38)),
              title: Text(
                title,
                style: Styles.k18Bold(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: LastMessageText(
                chatRoom: room,
              ),
              trailing: ListTileTrailing(
                deleteChatRoom: deleteChatRoom,
                undoDeletion: undoDeletion,
              ),
            )),
      ),
    );
  }
}

class PrivateRoomListTile extends ConsumerWidget {
  const PrivateRoomListTile(
      {super.key,
      required this.chatRoom,
      required this.deleteChatRoom,
      required this.undoDeletion,
      required this.isLoading});
  final ChatRoom chatRoom;
  final Future<void> Function(WidgetRef ref) deleteChatRoom;
  final Future<void> Function(WidgetRef ref) undoDeletion;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final peerId =
        chatRoom.memberIds.firstWhere((element) => element != userId);
    final peer = chatRoom.members.members[peerId];
    final peerName = peer?.name ?? 'Jose Rizal';
    return RoomListTileBase(
      room: chatRoom,
      isLoading: isLoading,
      onTap: () => ref.read(appUserRepositoryProvider).getAppUser(peerId).then(
          (peerUser) => context.pushNamed(RoutePath.chatRoom.name,
              pathParameters: {'chatRoomId': chatRoom.id}, extra: peerUser)),
      title: peerName,
      deleteChatRoom: deleteChatRoom,
      undoDeletion: undoDeletion,
    );
  }
}

class GroupChatListTile extends ConsumerWidget {
  const GroupChatListTile(
      {super.key,
      required this.chatRoom,
      required this.deleteChatRoom,
      required this.undoDeletion,
      required this.isLoading});
  final ChatRoom chatRoom;
  final Future<void> Function(WidgetRef ref) deleteChatRoom;
  final Future<void> Function(WidgetRef ref) undoDeletion;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RoomListTileBase(
      room: chatRoom,
      isLoading: isLoading,
      onTap: () => context.pushNamed(RoutePath.groupChatScreen.name,
          pathParameters: {'chatRoomId': chatRoom.id}),
      title: chatRoom.chatRoomTitle,
      deleteChatRoom: deleteChatRoom,
      undoDeletion: undoDeletion,
    );
  }
}
