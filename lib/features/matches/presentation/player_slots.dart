import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/profile/presentation/user_profile_provider.dart';
import 'package:material_ui/material_ui.dart';

class PlayerSlots extends StatelessWidget {
  const PlayerSlots({
    super.key,
    required this.playerIds,
    required this.maxPlayers,
  });

  final List<String> playerIds;
  final int maxPlayers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < maxPlayers; i++)
          _PlayerSlot(uid: i < playerIds.length ? playerIds[i] : null),
      ],
    );
  }
}

class _PlayerSlot extends ConsumerWidget {
  const _PlayerSlot({required this.uid});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final uid = this.uid;
    final nickname = uid == null
        ? null
        : ref.watch(userProfileProvider(uid)).value?.nickname;

    return SizedBox(
      width: 56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (uid == null)
            CustomPaint(
              size: const Size(40, 40),
              painter: _DashedCirclePainter(color: colors.outline),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add, color: colors.outline),
              ),
            )
          else
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.primary,
              child: Text(
                (nickname == null || nickname.isEmpty)
                    ? '?'
                    : nickname[0].toUpperCase(),
                style: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 4),
          SizedBox(
            height: 14,
            child: Text(
              nickname ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..addOval(Offset.zero & size);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 4), paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
