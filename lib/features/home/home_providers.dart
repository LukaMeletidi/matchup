import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/matches_providers.dart';

class SelectedDayNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  void select(DateTime? day) => state = day;
}

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime?>(
  SelectedDayNotifier.new,
);

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

List<SportMatch> filterByDay(List<SportMatch> matches, DateTime? day) {
  if (day == null) return matches;
  return matches.where((match) => isSameDay(match.startsAt, day)).toList();
}

final visibleMatchesProvider = Provider<AsyncValue<List<SportMatch>>>((ref) {
  final matches = ref.watch(upcomingMatchesProvider);
  final day = ref.watch(selectedDayProvider);
  return matches.whenData((list) => filterByDay(list, day));
});
