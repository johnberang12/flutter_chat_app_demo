// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/firestore/firestore_service.dart';
import '../../authentication/data/auth_repository.dart';
import '../../users/domain/app_user.dart';
import '../data/chat_room_repository.dart';
import '../domain/chat_member.dart';
import '../domain/chat_room.dart';
import '../domain/room_activity.dart';
import '../domain/room_members.dart';
import '../sub_features/group_chat/selected_group_chat_members_list.dart';

class GroupChatRoomService {
  GroupChatRoomService({required this.ref});
  final Ref ref;

  ChatRoomRepository _chatRoomRepo() => ref.read(chatRoomRepositoryProvider);

  Future<void> createGroupChat(String chatRoomTitle) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      throw Exception(
          'Something went wrong. Please try to logout and log back in.'); // Throwing a proper exception
    }
    final now = currentDate();
    final id = now.toString();
    final selectedMembers = ref.read(selectedGroupChatMembersProvider);

    final chatRoom = ChatRoom(
        id: id,
        chatRoomTitle: chatRoomTitle,
        memberIds: _memberIds(user, selectedMembers),
        members: _groupChatMembers(user, selectedMembers),
        activity: _createRoomActivity(user, now),
        isGroup: true);
    await _chatRoomRepo().createChatRoom(chatRoom);
  }

  RoomActivity _createRoomActivity(User user, DateTime now) {
    return RoomActivity(
      lastMessage: '',
      senderId: '',
      createdAt: now,
      senderName: '',
    );
  }

  List<String> _memberIds(User user, List<AppUser?> selectedMembers) {
    // Start with the current user's ID.
    List<String> ids = [user.uid];

    // Add IDs of all non-null selected members.
    for (var member in selectedMembers) {
      if (member != null && !ids.contains(member.uid)) {
        // Ensure we only add non-null members.
        ids.add(member.uid);
      }
    }
    // return ids.toSet().toList();
    return {...ids}.toList();
  }

  RoomMembers _groupChatMembers(User user, List<AppUser?> selectedMembers) {
    final membersList = <ChatMember>[];
    // Add the current user as an admin.
    membersList.add(_chatRoomMember(
        userId: user.uid,
        name: user.displayName ?? '',
        isAdmin: true,
        imageUrl: user.photoURL));

    // Add the selected members.
    for (var member in selectedMembers) {
      if (member != null) {
        // Ensure we only process non-null members.
        // _addMemberToRoom(members, userId: member.uid, name: member.name);
        membersList.add(_chatRoomMember(
            userId: member.uid, name: member.name, imageUrl: member.photoUrl));
      }
    }
    return RoomMembers().addMembers(membersList.toSet().toList());
  }

  ChatMember _chatRoomMember(
      {required String userId,
      required String name,
      required String? imageUrl,
      bool isAdmin = false}) {
    final memberData = ChatMemberData(
        uid: userId, isAdmin: isAdmin, name: name, imageUrl: imageUrl ?? "");
    final chatMember = ChatMember(userId: userId, data: memberData);
    return chatMember;
  }

  Future<void> addChatRoomMember(ChatRoom chatRoom, AppUser appUser) async {
    /// return immediately if the to-add-user is already a member
    if (chatRoom.memberIds.contains(appUser.uid)) return;

    ///create new sets of members
    final newMembers = chatRoom.members.addMember(_chatRoomMember(
        userId: appUser.uid, name: appUser.name, imageUrl: appUser.photoUrl));

    ///create new chatRoom passing the new set of members and added memberIds
    final newChatRoom = chatRoom.copyWith(
        members: newMembers, memberIds: [...chatRoom.memberIds, appUser.uid]);

    ///recreate the chatRoom
    await _chatRoomRepo().createChatRoom(newChatRoom);
  }
}

final groupChatRoomServiceProvider =
    Provider<GroupChatRoomService>((ref) => GroupChatRoomService(ref: ref));
    // print('adding member...');
    // for (var i = 0; i < 5; i++) {
    //   await Future.delayed(const Duration(milliseconds: 1000));
    //   print('iterating...$i');
    //   print('I love you April...');
    // }
    // return;