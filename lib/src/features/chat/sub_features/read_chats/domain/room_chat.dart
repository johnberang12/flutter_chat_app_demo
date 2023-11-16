// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import '../../../domain/chat.dart';
// import '../../../domain/chat_room.dart';

// ///a class that encapsulates the ChatRoom and the last Chat
// class RoomChat {
//   RoomChat({
//     required this.chatRoom,
//     required this.chat,
//   });
//   final ChatRoom chatRoom;
//   final Chat chat;

//   @override
//   bool operator ==(covariant RoomChat other) {
//     if (identical(this, other)) return true;

//     return other.chatRoom == chatRoom && other.chat == chat;
//   }

//   @override
//   int get hashCode => chatRoom.hashCode ^ chat.hashCode;

//   @override
//   String toString() => 'RoomChat(chatRoom: $chatRoom, chat: $chat)';

//   RoomChat copyWith({
//     ChatRoom? chatRoom,
//     Chat? chat,
//   }) {
//     return RoomChat(
//       chatRoom: chatRoom ?? this.chatRoom,
//       chat: chat ?? this.chat,
//     );
//   }
// }
