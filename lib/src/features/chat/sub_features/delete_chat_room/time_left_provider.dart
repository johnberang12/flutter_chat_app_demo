import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeLeftNotifier extends StateNotifier<Duration> {
  TimeLeftNotifier(this.deletedAt) : super(const Duration(minutes: 3)) {
    _startTimer();
  }
  final DateTime deletedAt;

  void _startTimer() {
    const gracePeriod = Duration(minutes: 3);
    DateTime expirationTime = deletedAt.add(gracePeriod);
    _tickTock(expirationTime);
  }

  Future<void> _tickTock(DateTime expirationTime) async {
    Duration timeLeft = expirationTime.difference(DateTime.now());
    if (timeLeft.isNegative) {
      if (mounted) {
        state = Duration.zero;
      }
    } else {
      if (mounted) {
        state = timeLeft;
      }

      await Future.delayed(const Duration(seconds: 1));
      _tickTock(expirationTime);
    }
  }
}

final timeLeftProvider = StateNotifierProvider.autoDispose
    .family<TimeLeftNotifier, Duration, DateTime>(
        (ref, deletedAt) => TimeLeftNotifier(deletedAt));
