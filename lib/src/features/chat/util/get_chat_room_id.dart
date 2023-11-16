import '../../users/domain/app_user.dart';
import '../domain/chat_room.dart';

ChatRoomID getChatRoomId(UserID userId, UserID peerId) {
  final ids = [peerId, userId];

  ///The sorting is important to make sure
  ///either user gets the same id
  ids.sort();
  return ids.join('-');
}
