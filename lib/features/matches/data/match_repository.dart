import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/core/firebase/firebase_providers.dart';
import 'package:matchup/features/matches/domain/sport.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';

class MatchRepository {
  MatchRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _matches =>
      _firestore.collection('matches');

  Stream<List<SportMatch>> watchUpcomingMatches() {
    return _matches
        .where('startsAt', isGreaterThan: Timestamp.now())
        .orderBy('startsAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
  }

  Future<void> createMatch({
    required Sport sport,
    required String organizerId,
    required String venueName,
    required DateTime startsAt,
  }) {
    return _matches.add({
      'sportId': sport.id,
      'organizerId': organizerId,
      'venueName': venueName,
      'startsAt': Timestamp.fromDate(startsAt),
      'maxPlayers': sport.maxPlayers,
      'playerIds': [organizerId],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  SportMatch _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SportMatch(
      id: doc.id,
      sportId: data['sportId'] as String,
      organizerId: data['organizerId'] as String,
      venueName: data['venueName'] as String,
      startsAt: (data['startsAt'] as Timestamp).toDate(),
      maxPlayers: data['maxPlayers'] as int,
      playerIds: List<String>.from(data['playerIds'] as List),
    );
  }
}

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => MatchRepository(ref.watch(firestoreProvider)),
);
