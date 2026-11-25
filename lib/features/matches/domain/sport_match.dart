import 'package:matchup/features/matches/domain/match_enums.dart';

class SportMatch {
  const SportMatch({
    required this.id,
    required this.sportId,
    required this.organizerId,
    required this.venueName,
    required this.title,
    required this.format,
    required this.kind,
    required this.pricePerPlayer,
    required this.startsAt,
    required this.maxPlayers,
    required this.playerIds,
  });

  final String id;
  final String sportId;
  final String organizerId;
  final String venueName;
  final String title;
  final MatchFormat format;
  final MatchKind kind;
  final int pricePerPlayer;
  final DateTime startsAt;
  final int maxPlayers;
  final List<String> playerIds;

  bool get isFull => playerIds.length >= maxPlayers;

  bool hasPlayer(String uid) => playerIds.contains(uid);
}
