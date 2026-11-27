import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/data/match_repository.dart';

class MatchActionsController extends AsyncNotifier<void> {
  MatchActionsController(this.matchId);

  final String matchId;

  @override
  FutureOr<void> build() {}

  Future<void> join() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(matchRepositoryProvider)
          .joinMatch(matchId: matchId, uid: uid),
    );
  }

  Future<void> leave() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(matchRepositoryProvider)
          .leaveMatch(matchId: matchId, uid: uid),
    );
  }
}

final matchActionsControllerProvider =
    AsyncNotifierProvider.family<MatchActionsController, void, String>(
      MatchActionsController.new,
    );
