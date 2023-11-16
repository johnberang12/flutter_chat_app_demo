// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:flutter_chat_app/src/utils/image_url_chekcker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../users/domain/app_user.dart';

class EditProfileService {
  EditProfileService({required this.ref});
  final Ref ref;
  Future<void> updateDisplayName(UserID userId, String name) async {
    if (name.length < 4) {
      throw Exception('Name must be more than 3 characters long.');
    }
    await ref
        .read(appUserRepositoryProvider)
        .updateAppUser(userId, {'name': name}).then((value) => ref
            .read(authRepositoryProvider)
            .currentUser
            ?.updateDisplayName(name));
  }

  Future<void> updatePhotoUrl(UserID userId, String photoUrl) async {
    if (photoUrl.isEmpty) return;
    final validUrl = await checkImageUrl(photoUrl);
    await ref
        .read(appUserRepositoryProvider)
        .updateAppUser(userId, {'photoUrl': validUrl}).then((value) => ref
            .read(authRepositoryProvider)
            .currentUser
            ?.updatePhotoURL(validUrl));
  }
}

final editProfileServiceProvider =
    Provider<EditProfileService>((ref) => EditProfileService(ref: ref));
