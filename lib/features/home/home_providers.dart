import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/matches_providers.dart';

enum HomeTab { public, mine }

class HomeTabNotifier extends Notifier<HomeTab> {
  @override
  HomeTab build() => HomeTab.public;

  void select(HomeTab tab) => state = tab;
}

final homeTabProvider = NotifierProvider<HomeTabNotifier, HomeTab>(
  HomeTabNotifier.new,
);

List<SportMatch> filterByTab(
  List<SportMatch> matches,
  HomeTab tab,
  String? uid,
) {
  return switch (tab) {
    HomeTab.public => matches,
    HomeTab.mine =>
      uid == null ? [] : matches.where((m) => m.hasPlayer(uid)).toList(),
  };
}

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
  final tab = ref.watch(homeTabProvider);
  final uid = ref.watch(authStateProvider).value?.uid;

  return matches.whenData(
    (list) => filterByDay(filterByTab(list, tab, uid), day),
  );
});
