import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/chat_badge/presentation/chat_room_list_tile_badge.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/delete_chat_room/time_left_widget.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/presentation/unread_text_wrapper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widgets/alert_dialogs.dart';
import '../../../../common_widgets/widget_loader.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/styles.dart';
import '../../../app_router/app_router.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../users/data/app_user_repository.dart';
import '../../../users/domain/app_user.dart';
import '../../domain/chat_room.dart';
import '../../sub_features/delete_chat_room/delete_chat_room_controller.dart';
import '../../sub_features/typing_indicator/presentation/list_tile_typing_indicator.dart';

class ChatRoomListTile extends HookConsumerWidget {
  const ChatRoomListTile({super.key});

  Future<void> _deleteChatRoom(WidgetRef ref) async {
    ///delete operation here
    final room = ref.read(chatRoomProvider);
    await ref
        .read(deleteChatRoomControllerProvider.notifier)
        .deleteChatRoom(room);
  }

  Future<void> _undoDeletion(WidgetRef ref) async {
    ///undo deleted conversation here
    final room = ref.read(chatRoomProvider);
    await ref
        .read(deleteChatRoomControllerProvider.notifier)
        .undoDeletion(room.id);
  }

  Future<void> _enterChatRoom(
      BuildContext context, WidgetRef ref, UserID peerId) async {
    await ref.read(appUserFutureProvider(peerId).future).then((peerUser) {
      if (peerUser != null) {
        context.pushNamed(RoutePath.chatRoom.name, extra: peerUser);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeerId = useState<UserID?>(null);
    final room = ref.watch(chatRoomProvider);
    final state = ref.watch(deleteChatRoomControllerProvider);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final peerId = room.memberIds.firstWhere((element) => element != userId);
    final peer = room.members.members[peerId];
    final peerName = peer?.name ?? 'Jose Rizal';
    final isListTile = selectedPeerId.value == peerId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: WidgetLoader(
        isLoading: isListTile && state.isLoading,
        child: ChatRoomListTileBadge(
            room: room,
            child: ListTile(
              onTap: () => _enterChatRoom(context, ref, peerId),
              // () => context.pushNamed(RoutePath.chatRoom.name),
              tileColor: Colors.amber.shade300,
              leading: const CircleAvatar(
                  radius: 40, child: Icon(Icons.person, size: 48)),
              title: Text(
                peerName,
                style: Styles.k18Bold(context),
              ),
              subtitle: ListTileTypingIndicator(
                  peerData: peer,
                  child: UnreadTextWrapper(
                    activity: room.activity,
                  )),
              trailing: _ListTileTrailing(
                peerId: peerId,
                deleteChatRoom: (ref) =>
                    _confirmDeletion(context, ref, peerId, selectedPeerId),
                undoDeletion: (ref) =>
                    _assignPeedId(ref, selectedPeerId, peerId, _undoDeletion),
              ),
            )),
      ),
    );
  }

  Future<void> _assignPeedId(
      WidgetRef ref,
      ValueNotifier<UserID?> selectedPeerId,
      UserID peerId,
      Future<void> Function(WidgetRef) action) async {
    selectedPeerId.value = peerId;
    await action(ref);
    // selectedPeerId.value = null;
  }

  Future<void> _confirmDeletion(BuildContext context, WidgetRef ref,
          UserID peerId, ValueNotifier<UserID?> selectedPeerId) async =>
      showConfirmationDialog(
          context: context,
          defaultActionText: "Delete",
          cancelActionText: 'Cancel',
          title: 'Confirm deletion',
          content: 'Are you sure you want to delete this entire conversation?',
          onConfirm: () =>
              _assignPeedId(ref, selectedPeerId, peerId, _deleteChatRoom));
}

class _ListTileTrailing extends ConsumerWidget {
  const _ListTileTrailing(
      {required this.peerId,
      required this.deleteChatRoom,
      required this.undoDeletion});
  final UserID peerId;
  final Future<void> Function(WidgetRef) deleteChatRoom;
  final Future<void> Function(WidgetRef) undoDeletion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(chatRoomProvider);
    final deletedAt = room.deletedAt;
    return deletedAt != null
        ? _UndoButton(undoDeletion: undoDeletion, deletedAt: deletedAt)
        : _DeleteOptionWidget(deleteChatRoom: deleteChatRoom);
  }
}

class _UndoButton extends ConsumerWidget {
  const _UndoButton({required this.undoDeletion, required this.deletedAt});
  final DateTime deletedAt;
  final Future<void> Function(WidgetRef) undoDeletion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => undoDeletion(ref),
          child: Text(
            'Undo',
            style: Styles.k16Bold(context).copyWith(color: Colors.purple),
          ),
        ),
        Expanded(child: TimeLeftWidget(deletedAt: deletedAt))
      ],
    );
  }
}

class _DeleteOptionWidget extends HookConsumerWidget {
  const _DeleteOptionWidget({required this.deleteChatRoom});
  final Future<void> Function(WidgetRef) deleteChatRoom;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        onSelected: (value) => _onSelectMenu(ref, value),
        itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      gapW8,
                      Text('Delete')
                    ],
                  )),
              const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [Icon(Icons.cancel), gapW8, Text('Cancel')],
                  )),
            ]);
  }

  Future<void> _onSelectMenu(WidgetRef ref, int? value) async {
    if (value == null) return;
    if (value == 0) {
      await deleteChatRoom(ref);
    }
  }
}

final chatRoomProvider =
    Provider<ChatRoom>((ref) => throw UnimplementedError());
