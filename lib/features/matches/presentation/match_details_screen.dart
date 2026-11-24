import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/match_actions_controller.dart';
import 'package:matchup/features/matches/presentation/match_error_message.dart';
import 'package:matchup/features/matches/presentation/matches_providers.dart';
import 'package:matchup/features/profile/presentation/user_profile_provider.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class MatchDetailsScreen extends ConsumerWidget {
  const MatchDetailsScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final match = ref.watch(matchProvider(matchId));
    final uid = ref.watch(authStateProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(match.value?.venueName ?? '')),
      body: match.when(
        error: ((error, stack) => Center(child: Text(l10n.genericError))),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (item) {
          if (item == null) return Center(child: Text(l10n.matchNotFound));
          final time = TimeOfDay.fromDateTime(item.startsAt);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${materialL10n.formatFullDate(item.startsAt)}, '
                '${materialL10n.formatTimeOfDay(time)}',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.playersCount(item.playerIds.length, item.maxPlayers),
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              for (final playerId in item.playerIds) _PlayerTile(uid: playerId),
              const SizedBox(height: 24),
              if (uid != null && item.organizerId != uid)
                _JoinLeaveButton(match: item, uid: uid),
            ],
          );
        },
      ),
    );
  }
}

class _PlayerTile extends ConsumerWidget {
  const _PlayerTile({required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider(uid));

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(profile.value?.nickname ?? l10n.unknownPlayer),
    );
  }
}

class _JoinLeaveButton extends ConsumerWidget {
  const _JoinLeaveButton({required this.match, required this.uid});

  final SportMatch match;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(matchActionsControllerProvider).isLoading;
    final controller = ref.read(matchActionsControllerProvider.notifier);
    final isPlayer = match.hasPlayer(uid);
    final canPress = !isLoading && (isPlayer || !match.isFull);

    ref.listen(matchActionsControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(matchErrorMessage(next.error!, l10n))),
        );
      }
    });

    return FilledButton(
      onPressed: canPress
          ? () => isPlayer
                ? controller.leave(match.id)
                : controller.join(match.id)
          : null,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(isPlayer ? l10n.leave : l10n.join),
    );
  }
}
