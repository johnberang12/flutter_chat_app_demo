import 'package:flutter_chat_app/src/features/users/application/app_user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/app_user.dart';

class HomeScreenController extends StateNotifier<AsyncValue<void>> {
  HomeScreenController({required this.service}) : super(const AsyncData(null));
  final AppUserService service;

  Future<void> createAppUser(AppUser appUser) async {
    state = const AsyncLoading();
    final newState =
        await AsyncValue.guard(() => service.createAppUser(appUser));
    if (mounted) {
      state = newState;
    }
  }

  Future<void> deleteUser(UserID userId) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => service.deleteUser(userId));
    if (mounted) {
      state = newState;
    }
  }
}

final homeScreenControllerProvider =
    StateNotifierProvider.autoDispose<HomeScreenController, AsyncValue<void>>(
        (ref) =>
            HomeScreenController(service: ref.watch(appUserServiceProvider)));
