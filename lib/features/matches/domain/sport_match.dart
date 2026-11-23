class SportMatch {
  const SportMatch({
    required this.id,
    required this.sportId,
    required this.organizerId,
    required this.venueName,
    required this.startsAt,
    required this.maxPlayers,
    required this.playerIds,
  });

  final String id;
  final String sportId;
  final String organizerId;
  final String venueName;
  final DateTime startsAt;
  final int maxPlayers;
  final List<String> playerIds;

  bool get isFull => playerIds.length >= maxPlayers;

  bool hasPlayer(String uid) => playerIds.contains(uid);
}
