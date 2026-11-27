import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/data/match_repository.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';

final upcomingMatchesProvider = StreamProvider<List<SportMatch>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(matchRepositoryProvider).watchUpcomingMatches();
});

final matchProvider = StreamProvider.family<SportMatch?, String>((
  ref,
  matchId,
) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(matchRepositoryProvider).watchMatch(matchId);
});

final myPastMatchesProvider = StreamProvider<List<SportMatch>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(matchRepositoryProvider).watchMyPastMatches(user.uid);
});
