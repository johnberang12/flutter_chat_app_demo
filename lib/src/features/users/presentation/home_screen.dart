import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_chat_app/src/common_widgets/screen_loader.dart';
import 'package:flutter_chat_app/src/features/users/presentation/home_screen_controller.dart';
import 'package:flutter_chat_app/src/features/users/presentation/paginator_controller.dart';
import 'package:flutter_chat_app/src/features/users/presentation/user_paginator_builder.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_router/app_router.dart';
import '../../search/presentation/home_search_widget.dart';
import '../../search/presentation/search_screen.dart';
import '../common_widget/users_fetch_widget.dart';
import '../domain/app_user.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  Future<void> onCreateAppUser(
      WidgetRef ref, ValueNotifier<bool> isAdding) async {
    //*create new AppUser
    final faker = Faker();
    final uid = DateTime.now().toIso8601String();
    final name = faker.person.name();
    final phoneNumber = '+${faker.phoneNumber.random.numberOfLength(12)}';
    final title = faker.job.title();
    final appUser =
        AppUser(uid: uid, name: name, phoneNumber: phoneNumber, title: title);
    isAdding.value = true;
    await ref
        .read(homeScreenControllerProvider.notifier)
        .createAppUser(appUser);
    isAdding.value = false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<AsyncValue>(homeScreenControllerProvider,
    //     (_, next) => next.showAlertDialogOnError(context));
    final state = ref.watch(homeScreenControllerProvider);
    // final usersValue = ref.watch(appUsersStreamProvider);
    final isAdding = useState<bool>(false);
    return Scaffold(
        appBar: AppBar(
          title: HomeSearchWidget(
              onTap: () => showSearch(
                  context: context,
                  useRootNavigator: true,
                  delegate: SearchScreen(ref: ref))),
        ),
        body: ScreenLoader(
            isLoading: false,
            //  state.isLoading && isAdding.value,
            child: RefreshIndicator(
              onRefresh: () async {
                ref
                    .read(paginatorControllerProvider.notifier)
                    .fetchMore(isRefresh: true);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child:
                    // AppUserStreamList()

                    UserPaginatorBuilder(
                        itemBuilder: (controller, usersValue) =>
                            UsersFetchWidget(
                                onTap: (user) => context.pushNamed(
                                    RoutePath.userDetails.name,
                                    extra: user),
                                controller: controller,
                                usersValue: usersValue)),
              ),
            )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () => onCreateAppUser(ref, isAdding),
            child: state.isLoading
                ? AppLoader.circularProgress()
                : const Icon(Icons.add)));
  }
}
