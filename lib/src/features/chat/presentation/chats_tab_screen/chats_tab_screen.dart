import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/async_value_when.dart';
import 'package:flutter_chat_app/src/common_widgets/center_text.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/delete_chat_room/delete_chat_room_controller.dart';

import 'package:flutter_chat_app/src/features/chat/sub_features/delete_chat_room/time_left_provider.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/chat_room_service.dart';
import '../../domain/chat_room.dart';
import 'chat_room_list_tile.dart';

class ChatsTabScreen extends ConsumerWidget {
  const ChatsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(deleteChatRoomControllerProvider,
        (previous, next) => next.showAlertDialogOnError(context));
    // final state = ref.watch(chatsScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chats Screen')),
      body: const ChatsScreenBody(),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.amber,
      //     onPressed: () =>
      //         ref.read(chatsScreenControllerProvider.notifier).createChatRoom(),
      //     child: state.isLoading
      //         ? AppLoader.circularProgress()
      //         : const Icon(Icons.add)),
    );
  }
}

class ChatsScreenBody extends ConsumerWidget {
  const ChatsScreenBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsValue = ref.watch(chatRoomsStreamProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AsyncValueWhen(
          value: roomsValue,
          data: (rooms) => rooms.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => const SizedBox(),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    if (room == null) return const SizedBox();
                    final isDeleted = room.deleted;
                    return ProviderScope(
                        overrides: [chatRoomProvider.overrideWithValue(room)],
                        child: isDeleted
                            ? DeletionCheckWrapper(
                                room: room, child: const ChatRoomListTile())
                            : const ChatRoomListTile());
                  },
                )
              : const CenterText(text: 'You have no chats Available')),
    );
  }
}

class DeletionCheckWrapper extends ConsumerWidget {
  const DeletionCheckWrapper(
      {super.key, required this.room, required this.child});
  final Widget child;
  final ChatRoom room;

  bool _isTicking(
    WidgetRef ref,
    DateTime? deletedAt,
  ) {
    if (deletedAt == null) return false;
    final timeLeft = ref.watch(timeLeftProvider(deletedAt));
    return timeLeft != Duration.zero;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedAt = room.deletedAt;
    final isTicking = _isTicking(ref, deletedAt);
    return isTicking
        ? Opacity(opacity: isTicking ? 0.5 : 1.0, child: child)
        : const SizedBox();
  }
}
