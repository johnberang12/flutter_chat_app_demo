// import 'package:flutter/material.dart';
// import 'package:flutter_chat_app/src/common_widgets/widget_loader.dart';
// import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/presentation/read_chats_controller.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../sub_features/read_chats/domain/room_chat.dart';

// class ReadChatsControllerListener extends ConsumerStatefulWidget {
//   const ReadChatsControllerListener(
//       {super.key, required this.roomChat, required this.child});
//   final Widget child;
//   final RoomChat roomChat;

//   @override
//   ConsumerState<ReadChatsControllerListener> createState() =>
//       _ReadChatsControllerListenerState();
// }

// class _ReadChatsControllerListenerState
//     extends ConsumerState<ReadChatsControllerListener> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref
//           .read(readChatsControllerProvider(widget.roomChat).notifier)
//           .readChats();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(
//         readChatsControllerProvider(widget.roomChat), (previous, next) {});
//     // final state = ref.watch(readChatsControllerProvider(chatRoom));
//     return WidgetLoader(isLoading: false, child: widget.child);
//   }
// }
