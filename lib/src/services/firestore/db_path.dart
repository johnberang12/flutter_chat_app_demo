import '../../features/chat/domain/chat.dart';
import '../../features/chat/domain/chat_room.dart';
import '../../features/users/domain/app_user.dart';

class DBPath {
  static String user(UserID userId) => 'users/$userId';
  static String users() => 'users';

  static String chatRoom(ChatRoomID chatRoomId) => 'rooms/$chatRoomId';
  static String chatRooms() => 'rooms';

  static String chat(ChatRoomID chatRoomId, ChatID chatId) =>
      'rooms/$chatRoomId/chats/$chatId';
  static String chats(ChatRoomID chatRoomId) => '${chatRoom(chatRoomId)}/chats';

  ///you can add more paths here if needed
}
