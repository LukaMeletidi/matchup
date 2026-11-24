import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/matches/presentation/court_painter.dart';
import 'package:matchup/features/profile/presentation/user_profile_provider.dart';
import 'package:material_ui/material_ui.dart';

class CourtView extends StatelessWidget {
  const CourtView({super.key, required this.playerIds});

  final List<String> playerIds;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: AspectRatio(
          aspectRatio: 10 / 15,
          child: CustomPaint(
            painter: CourtPainter(
              courtColor: colors.primaryContainer,
              lineColor: colors.onPrimaryContainer,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Center(child: _seatAt(0))),
                      Expanded(child: Center(child: _seatAt(1))),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Center(child: _seatAt(2))),
                      Expanded(child: Center(child: _seatAt(3))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _seatAt(int index) {
    return _Seat(uid: index < playerIds.length ? playerIds[index] : null);
  }
}

class _Seat extends ConsumerWidget {
  const _Seat({required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final uid = this.uid;
    final nickname = uid == null
        ? null
        : ref.watch(userProfileProvider(uid)).value?.nickname;

    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (uid == null)
            CircleAvatar(
              backgroundColor: colors.surface,
              child: Icon(Icons.add, color: colors.onSurfaceVariant),
            )
          else
            CircleAvatar(
              backgroundColor: colors.primary,
              child: Icon(Icons.person, color: colors.onPrimary),
            ),
          const SizedBox(height: 4),
          SizedBox(
            height: 16,
            child: Text(
              nickname ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
