import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/core/firebase/firebase_providers.dart';
import 'package:matchup/features/matches/domain/match_exceptions.dart';
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

  Stream<SportMatch?> watchMatch(String matchId) {
    return _matches
        .doc(matchId)
        .snapshots()
        .map((doc) => doc.exists ? _fromDoc(doc) : null);
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

  Future<void> joinMatch({required String matchId, required String uid}) {
    final ref = _matches.doc(matchId);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) throw const MatchNotFoundException();

      final match = _fromDoc(snapshot);
      if (match.hasPlayer(uid)) return;
      if (match.isFull) throw const MatchFullException();

      transaction.update(ref, {
        'playerIds': FieldValue.arrayUnion([uid]),
      });
    });
  }

  Future<void> leaveMatch({required String matchId, required String uid}) {
    return _matches.doc(matchId).update({
      'playerIds': FieldValue.arrayRemove([uid]),
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
