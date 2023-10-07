import 'chat_room.dart';

extension MutableChatRoom on ChatRoom {
  // ChatRoom addMember(ChatMember member) {
  //   final copy = Map<UserID, ChatMemberData>.from(members.toMap());
  //   copy[member.userId] = member.data;
  //   return copyWith(members: RoomMembers.fromMap(copy));
  // }

  // ChatRoom addMembers(List<ChatMember> users) {
  //   // final copy = RoomMembers.fromMap(members.toMap());
  //   // for (var user in users) {
  //   //   // copy['members'] = {user.userId: user.data};
  //   // }
  //   // print('userLength: ${users.length}');
  //   // print('copy: $copy');
  //   return copyWith(members: members.addMembers(users));
  // }

  // ChatRoom removeMember(UserID userId) {
  //   final copy = Map<UserID, ChatMemberData>.from(members.toMap());
  //   copy.remove(userId);
  //   return copyWith(members: RoomMembers.fromMap(copy));
  // }

  // ChatRoom updateMember(UserID userId, ChatMemberData updatedMember) {
  //   final copy = Map<UserID, ChatMemberData>.from(members.toMap());
  //   copy[userId] = updatedMember;
  //   return copyWith(members: RoomMembers.fromMap(copy));
  // }
}
