import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';
import 'package:matchup/features/matches/presentation/match_actions_controller.dart';
import 'package:matchup/features/matches/presentation/match_error_message.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class MatchJoinButton extends ConsumerWidget {
  const MatchJoinButton({super.key, required this.match});

  final SportMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final uid = ref.watch(authStateProvider).value?.uid;
    final provider = matchActionsControllerProvider(match.id);
    final isLoading = ref.watch(provider).isLoading;

    ref.listen(provider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(matchErrorMessage(next.error!, l10n))),
        );
      }
    });

    if (uid == null ||
        match.organizerId == uid ||
        match.startsAt.isBefore(DateTime.now())) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(provider.notifier);
    final isPlayer = match.hasPlayer(uid);
    final canPress = !isLoading && (isPlayer || !match.isFull);

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: canPress
            ? () => isPlayer ? controller.leave() : controller.join()
            : null,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : Text(isPlayer ? l10n.leave : l10n.join),
      ),
    );
  }
}
