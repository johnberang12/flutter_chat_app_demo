import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/account/presentation/edit_profile_screen.dart';
import 'package:flutter_chat_app/src/features/app_router/app_route_redirect.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router_listenable.dart';
import 'package:flutter_chat_app/src/features/app_router/scaffold_with_nav_bar.dart';
import 'package:flutter_chat_app/src/features/authentication/signin_screen.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/group_chat/chat_members_screen.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/group_chat/create_group_chat_screen.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/group_chat/group_chat_screen.dart';
import 'package:flutter_chat_app/src/features/settings/settings_screen.dart';
import 'package:flutter_chat_app/src/features/users/presentation/name_registration_screen.dart';
import 'package:flutter_chat_app/src/features/users/presentation/user_detail_screen.dart';
import 'package:flutter_chat_app/src/features/welcome/welcome_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../account/presentation/account_screen.dart';
import '../chat/domain/chat_room.dart';
import '../chat/presentation/chat_room_screen/chat_screen.dart';
import '../chat/presentation/chats_tab_screen/chats_tab_screen.dart';
import '../users/domain/app_user.dart';
import '../users/presentation/home_screen.dart';

enum RoutePath {
  root(path: '/'),
  welcome(path: 'welcome'),
  signin(path: 'signin'),
  home(path: 'home'),
  home2(path: 'home2'),
  settings(path: 'settings'),
  nameRegistration(path: 'nameReg'),
  notification(path: 'notification'),
  account(path: 'account'),
  userDetails(path: 'userDetails'),
  chatsTab(path: 'chats'),
  chatRoom(path: 'chatRoom/:chatRoomId'),
  createGroupChat(path: 'createGroupChat'),
  groupChatScreen(path: 'groupChatScreen/:chatRoomId'),
  chatMembersScreen(path: 'chatMembersScreen'),
  editProfile(path: 'editProfile'),
  userPagination(path: 'userPagination');

  const RoutePath({required this.path});
  final String path;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final rootNaveKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');
  final homeNaveKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
  final chatsNaveKey = GlobalKey<NavigatorState>(debugLabel: 'chatsNav');
  final accountNaveKey = GlobalKey<NavigatorState>(debugLabel: 'accountNav');

  final listenable = ref.watch(appRouterListenableProvider);
  return GoRouter(
      navigatorKey: rootNaveKey,
      refreshListenable: listenable,
      redirect: (context, state) => appRouteRedirect(context, ref, state),
      routes: [
        GoRoute(
            path: RoutePath.root.path,
            name: RoutePath.root.name,
            builder: (context, state) => const WelcomeScreen(),
            routes: [
              GoRoute(
                  path: RoutePath.signin.path,
                  name: RoutePath.signin.name,
                  builder: (context, state) => const SigninScreen()),
              GoRoute(
                  path: RoutePath.nameRegistration.path,
                  name: RoutePath.nameRegistration.name,
                  builder: (context, state) => const NameRegistrationScreen()),
              StatefulShellRoute.indexedStack(
                  builder: (context, state, navigationShell) =>
                      ScaffoldWithNavBar(navigationShell: navigationShell),
                  branches: [
                    StatefulShellBranch(
                      navigatorKey: homeNaveKey,
                      routes: <RouteBase>[
                        GoRoute(
                            path: RoutePath.home.path,
                            name: RoutePath.home.name,
                            builder: (context, state) => const HomeScreen()),
                      ],
                    ),
                    StatefulShellBranch(
                      navigatorKey: chatsNaveKey,
                      routes: <RouteBase>[
                        GoRoute(
                            path: RoutePath.chatsTab.path,
                            name: RoutePath.chatsTab.name,
                            builder: (context, state) => const ChatsTabScreen(),
                            routes: [
                              GoRoute(
                                  path: RoutePath.chatRoom.path,
                                  name: RoutePath.chatRoom.name,
                                  builder: (context, state) {
                                    final chatRoomId =
                                        state.pathParameters['chatRoomId']!;
                                    final peerUser = state.extra as AppUser;
                                    return ChatScreen(
                                      chatRoomId: chatRoomId,
                                      peerUser: peerUser,
                                    );
                                  }),
                            ]),
                      ],
                    ),
                    StatefulShellBranch(
                      navigatorKey: accountNaveKey,
                      routes: <RouteBase>[
                        GoRoute(
                            path: RoutePath.account.path,
                            name: RoutePath.account.name,
                            builder: (context, state) => const AccountScreen()),
                      ],
                    ),
                  ]),
              GoRoute(
                  path: RoutePath.userDetails.path,
                  name: RoutePath.userDetails.name,
                  builder: (context, state) {
                    final appUser = state.extra as AppUser;
                    return UserDetailScreen(appUser: appUser);
                  }),
              GoRoute(
                  path: RoutePath.createGroupChat.path,
                  name: RoutePath.createGroupChat.name,
                  builder: (context, state) {
                    return const CreateGroupChatScreen();
                  }),
              GoRoute(
                  path: RoutePath.groupChatScreen.path,
                  name: RoutePath.groupChatScreen.name,
                  builder: (context, state) {
                    final chatRoomId = state.pathParameters['chatRoomId']!;

                    return GroupChatScreen(chatRoomId: chatRoomId);
                  }),
              GoRoute(
                  path: RoutePath.chatMembersScreen.path,
                  name: RoutePath.chatMembersScreen.name,
                  builder: (context, state) {
                    final chatRoom = state.extra as ChatRoom;
                    return ChatMembersScreen(chatRoom: chatRoom);
                  }),
              GoRoute(
                  path: RoutePath.editProfile.path,
                  name: RoutePath.editProfile.name,
                  builder: (context, state) => const EditProfileScreen()),
              GoRoute(
                  path: RoutePath.settings.path,
                  name: RoutePath.settings.name,
                  builder: (context, state) => const SettingsScreen()),
            ])
      ]);
});
