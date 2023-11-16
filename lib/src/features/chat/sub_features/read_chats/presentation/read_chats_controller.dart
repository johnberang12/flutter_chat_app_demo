// import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/application/read_chats_service.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../domain/room_chat.dart';

// class ReadChatsController extends StateNotifier<AsyncValue<void>> {
//   ReadChatsController({required this.roomChat, required this.service})
//       : super(const AsyncData(null)) {
//     // _readChats();
//   }
//   final RoomChat roomChat;
//   final ReadChatsService service;

//   Future<void> readChats() async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(() => service.readChats(roomChat));
//     if (mounted) {
//       state = newState;
//     }
//   }
// }

// final readChatsControllerProvider = StateNotifierProvider.autoDispose
//     .family<ReadChatsController, AsyncValue<void>, RoomChat>((ref, roomChat) {
//   print('read chats controller created...');
//   ref.onDispose(() {
//     print('read chats controller dispose....');
//   });
//   return ReadChatsController(
//       roomChat: roomChat, service: ref.watch(readChatsServiceProvider));
// });
