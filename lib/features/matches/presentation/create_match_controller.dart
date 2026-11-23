import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/data/match_repository.dart';
import 'package:matchup/features/matches/domain/sport.dart';

class CreateMatchController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> createMatch({
    required String venueName,
    required DateTime startsAt,
  }) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(matchRepositoryProvider)
          .createMatch(
            sport: padel,
            organizerId: uid,
            venueName: venueName,
            startsAt: startsAt,
          ),
    );
    return !state.hasError;
  }
}

final createMatchControllerProvider =
    AsyncNotifierProvider<CreateMatchController, void>(
      CreateMatchController.new,
    );
