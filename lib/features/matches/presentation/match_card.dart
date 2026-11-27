import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/match_join_button.dart';
import 'package:matchup/features/matches/presentation/player_slots.dart';
import 'package:matchup/features/profile/presentation/user_profile_provider.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match});

  final SportMatch match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final time = TimeOfDay.fromDateTime(match.startsAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        onTap: () => context.push('/matches/${match.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                match.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      match.venueName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text(materialL10n.formatMediumDate(match.startsAt)),
                    const SizedBox(width: 12),
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 6),
                    Text(materialL10n.formatTimeOfDay(time)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  PlayerSlots(
                    playerIds: match.playerIds,
                    maxPlayers: match.maxPlayers,
                  ),
                  const Spacer(),
                  Text(
                    '${match.playerIds.length}/${match.maxPlayers}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OrganizerLabel(uid: match.organizerId),
                  Text(l10n.priceValue(match.pricePerPlayer)),
                ],
              ),
              const SizedBox(height: 12),
              MatchJoinButton(match: match),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrganizerLabel extends ConsumerWidget {
  const _OrganizerLabel({required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nickname = ref.watch(userProfileProvider(uid)).value?.nickname;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.organizerLabel,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          nickname ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
