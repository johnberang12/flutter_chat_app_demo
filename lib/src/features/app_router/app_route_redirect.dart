import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FutureOr<String?> appRouteRedirect(
    BuildContext context, Ref ref, GoRouterState state) async {
  final user = ref.read(authRepositoryProvider).currentUser;
  // print('userid: ${user?.uid}');
  // print('localtion: ${state.matchedLocation}');
  final loggingOut = user == null &&
      (state.matchedLocation == '/settings' ||
          state.matchedLocation == '/account');
  final loggedIn = user != null;
  final loggingIn =
      state.matchedLocation == '/' || state.matchedLocation == '/signin';
  if (loggingOut) return '/';
  if (loggedIn && loggingIn && user.displayName != null) {
    return '/home';
  }
  if (loggedIn && loggingIn && user.displayName == null) return '/nameReg';
  return null;
}
