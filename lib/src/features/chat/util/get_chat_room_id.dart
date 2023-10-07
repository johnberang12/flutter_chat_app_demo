import '../../users/domain/app_user.dart';
import '../domain/chat_room.dart';

ChatRoomID getChatRoomId(UserID userId, UserID peerId) {
  final ids = [peerId, userId];
  ids.sort();
  return ids.join();
}
