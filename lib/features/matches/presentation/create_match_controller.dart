import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/data/match_repository.dart';
import 'package:matchup/features/matches/domain/match_enums.dart';
import 'package:matchup/features/matches/domain/sport.dart';

class CreateMatchController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> createMatch({
    required String title,
    required String venueName,
    required MatchFormat format,
    required MatchKind kind,
    required int pricePerPlayer,
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
            title: title,
            venueName: venueName,
            format: format,
            kind: kind,
            pricePerPlayer: pricePerPlayer,
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
