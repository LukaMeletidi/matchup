class Sport {
  const Sport({required this.id, required this.maxPlayers});

  final String id;
  final int maxPlayers;
}

const padel = Sport(id: 'padel', maxPlayers: 4);
