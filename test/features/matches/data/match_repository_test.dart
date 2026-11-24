import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/features/matches/data/match_repository.dart';
import 'package:matchup/features/matches/domain/match_exceptions.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late MatchRepository repository;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    repository = MatchRepository(firestore);
    await firestore.collection('matches').doc('m1').set({
      'sportId': 'padel',
      'organizerId': 'org',
      'venueName': 'Test Club',
      'startsAt': Timestamp.fromDate(DateTime(2030, 1, 1, 18)),
      'maxPlayers': 4,
      'playerIds': ['org'],
    });
  });

  Future<void> setPlayers(List<String> playerIds) {
    return firestore.collection('matches').doc('m1').update({
      'playerIds': playerIds,
    });
  }

  Future<List<dynamic>> readPlayers() async {
    final doc = await firestore.collection('matches').doc('m1').get();
    return doc.data()!['playerIds'] as List<dynamic>;
  }

  group('MatchRepository join and leave', () {
    test('joinMatch adds the user to playerIds', () async {
      await repository.joinMatch(matchId: 'm1', uid: 'u1');

      expect(await readPlayers(), ['org', 'u1']);
    });

    test('joinMatch throws MatchFullException when full', () async {
      await setPlayers(['org', 'a', 'b', 'c']);

      await expectLater(
        () => repository.joinMatch(matchId: 'm1', uid: 'u1'),
        throwsA(isA<MatchFullException>()),
      );
      expect(await readPlayers(), ['org', 'a', 'b', 'c']);
    });

    test(
      'joinMatch throws MatchNotFoundException for a missing match',
      () async {
        await expectLater(
          () => repository.joinMatch(matchId: 'nope', uid: 'u1'),
          throwsA(isA<MatchNotFoundException>()),
        );
      },
    );

    test('leaveMatch removes the user from playerIds', () async {
      await setPlayers(['org', 'u1']);

      await repository.leaveMatch(matchId: 'm1', uid: 'u1');

      expect(await readPlayers(), ['org']);
    });
  });
}
