import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/court_view.dart';
import 'package:matchup/features/matches/presentation/match_actions_controller.dart';
import 'package:matchup/features/matches/presentation/match_error_message.dart';
import 'package:matchup/features/matches/presentation/match_labels.dart';
import 'package:matchup/features/matches/presentation/matches_providers.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class MatchDetailsScreen extends ConsumerWidget {
  const MatchDetailsScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final match = ref.watch(matchProvider(matchId));
    final uid = ref.watch(authStateProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.matchDetailsTitle)),
      body: match.when(
        error: ((error, stack) => Center(child: Text(l10n.genericError))),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (item) {
          if (item == null) return Center(child: Text(l10n.matchNotFound));
          return ListView(
            children: [
              _MatchHeader(match: item),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CourtView(playerIds: item.playerIds),
                    const SizedBox(height: 16),
                    Text(
                      l10n.playersCount(item.playerIds.length, item.maxPlayers),
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    if (uid != null && item.organizerId != uid)
                      _JoinLeaveButton(match: item, uid: uid),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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

class _MatchHeader extends StatelessWidget {
  const _MatchHeader({required this.match});

  final SportMatch match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final time = TimeOfDay.fromDateTime(match.startsAt);

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            match.title,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 18, color: Colors.white70),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  match.venueName,
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _HeaderLine(
                icon: Icons.event,
                text: materialL10n.formatMediumDate(match.startsAt),
              ),
              _HeaderLine(
                icon: Icons.schedule,
                text: materialL10n.formatTimeOfDay(time),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.sports_tennis,
                label: formatLabel(match.format, l10n),
              ),
              _InfoChip(
                icon: Icons.emoji_events_outlined,
                label: kindLabel(match.kind, l10n),
              ),
              _InfoChip(
                icon: Icons.payments_outlined,
                label: l10n.priceValue(match.pricePerPlayer),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderLine extends StatelessWidget {
  const _HeaderLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
