import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../common_widgets/app_loader.dart';
import '../../../../utils/invert_double.dart';

class ChatsRefresher extends HookWidget {
  //Unused Widget
  const ChatsRefresher(
      {super.key,
      required this.onRefresh,
      required this.fetchMore,
      required this.child});
  final Future<void> Function() onRefresh;
  final Future<void> Function() fetchMore;
  final Widget Function(ScrollController) child;

  Future<void> triggerFetch(
      ValueNotifier<bool> isLoading, Future<void> Function() callback) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      await callback();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final bottomScroll = useState(0.0);
    final topScroll = useState(0.0);
    final controller = useScrollController();
    void onScroll() async {
      topScroll.value =
          controller.position.maxScrollExtent - controller.position.pixels;

      bottomScroll.value = controller.position.pixels;

      // print('')
      if (topScroll.value < -5 && !isLoading.value) {
        ///fetch previous chats
        await triggerFetch(isLoading, fetchMore);
      }

      if (bottomScroll.value <= -120 && !isLoading.value) {
        ///refresh chats
        await triggerFetch(isLoading, onRefresh);
      }
    }

    useEffect(() {
      controller.addListener(onScroll);
      return () => controller.removeListener(onScroll);
    }, []);

    final double top = invertDouble(topScroll.value) + 20;
    final double bottom = invertDouble(bottomScroll.value) + 20;

    return Stack(
      alignment: Alignment.center,
      children: [
        child(controller),
        if (isLoading.value)
          Positioned(
            top: top.isNegative ? null : top,
            left: 0,
            right: 0,
            bottom: bottom.isNegative ? null : bottom,
            child: AppLoader.circularProgress(),
          ),
      ],
    );
  }
}
