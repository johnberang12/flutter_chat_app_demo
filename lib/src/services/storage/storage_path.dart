import '../../features/chat/domain/chat.dart';
import '../../features/chat/domain/chat_room.dart';

class StoragePath {
  static String chatImagePath(ChatRoomID roomId, ChatID chatId) =>
      'rooms/$roomId/chats/$chatId';
}
