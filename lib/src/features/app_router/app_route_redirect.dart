import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FutureOr<String?> appRouteRedirect(
    BuildContext context, Ref ref, GoRouterState state) async {
  final user = ref.read(authRepositoryProvider).currentUser;
  print('user: $user');
  final loggingOut = user == null && state.matchedLocation == '/settings';
  final loggedIn = user != null;
  final loggingIn =
      state.matchedLocation == '/' || state.matchedLocation == '/signin';
  if (loggingOut) return '/signin';
  if (loggedIn && loggingIn && user.displayName != null) return '/home';
  if (loggedIn && loggingIn && user.displayName == null) return '/nameReg';
  return null;
}
