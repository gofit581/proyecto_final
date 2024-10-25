import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> counterDayProvider = StateProvider<int>((ref) => 1);

void resetCounter(WidgetRef ref) {
  ref.read(counterDayProvider.notifier).state = 1;
}

void refillCounter(WidgetRef ref) {
  ref.read(counterDayProvider.notifier).state = 3;
}

final StateProvider<int> counterWeekProvider = StateProvider((ref)=>1);