import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/screen_loader.dart';
import 'package:flutter_chat_app/src/features/users/home_screen_controller.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/styles.dart';
import '../search/presentation/search_screen.dart';
import 'application/app_user_service.dart';
import 'common_widget/users_fetch_widget.dart';
import 'domain/app_user.dart';

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
    ref.listen<AsyncValue>(homeScreenControllerProvider,
        (_, next) => next.showAlertDialogOnError(context));
    final state = ref.watch(homeScreenControllerProvider);
    final usersValue = ref.watch(appUsersStreamProvider);
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
            isLoading: state.isLoading && isAdding.value,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: UsersFetchWidget(usersValue: usersValue),
            )),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () => onCreateAppUser(ref, isAdding),
            child: const Icon(Icons.add)));
  }
}

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: AppColors.grey500),
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: Text(
                      'Who are you looking for?',
                      style: Styles.k20(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(24)),
              child: const Center(
                child: Text('Search'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
