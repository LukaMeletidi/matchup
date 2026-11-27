import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/features/matches/data/match_repository.dart';
import 'package:matchup/features/matches/domain/match_enums.dart';
import 'package:matchup/features/matches/domain/match_exceptions.dart';
import 'package:matchup/features/matches/domain/sport.dart';

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
      'title': 'Test Match',
      'format': 'sets',
      'kind': 'friendly',
      'pricePerPlayer': 30,
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

  group('MatchRepository create and read', () {
    test('createMatch saves all match fields', () async {
      await repository.createMatch(
        sport: padel,
        organizerId: 'org2',
        title: 'Evening game',
        venueName: 'Test Club',
        format: MatchFormat.tournament,
        kind: MatchKind.ranked,
        pricePerPlayer: 40,
        startsAt: DateTime(2030, 1, 1, 18),
      );

      final snapshot = await firestore
          .collection('matches')
          .where('title', isEqualTo: 'Evening game')
          .get();
      final data = snapshot.docs.single.data();

      expect(data['sportId'], 'padel');
      expect(data['organizerId'], 'org2');
      expect(data['venueName'], 'Test Club');
      expect(data['format'], 'tournament');
      expect(data['kind'], 'ranked');
      expect(data['pricePerPlayer'], 40);
      expect(data['maxPlayers'], 4);
      expect(data['playerIds'], ['org2']);
    });

    test('watchMatch maps a document to a SportMatch', () async {
      final match = await repository.watchMatch('m1').first;

      expect(match, isNotNull);
      expect(match!.title, 'Test Match');
      expect(match.format, MatchFormat.sets);
      expect(match.kind, MatchKind.friendly);
      expect(match.pricePerPlayer, 30);
      expect(match.playerIds, ['org']);
    });
  });

  group('watchMyPastMatches', () {
    Future<void> addMatch(DateTime startsAt, List<String> playerIds) {
      return firestore.collection('matches').add({
        'sportId': 'padel',
        'organizerId': playerIds.first,
        'venueName': 'Club',
        'title': 'Test Match',
        'format': 'sets',
        'kind': 'friendly',
        'pricePerPlayer': 30,
        'startsAt': Timestamp.fromDate(startsAt),
        'maxPlayers': 4,
        'playerIds': playerIds,
      });
    }

    final past = DateTime.now().subtract(const Duration(days: 2));
    final future = DateTime.now().add(const Duration(days: 2));

    test('returns only past matches where the user plays', () async {
      await addMatch(past, ['u1']);
      await addMatch(future, ['u1']);
      await addMatch(past, ['u2']);

      final matches = await repository.watchMyPastMatches('u1').first;

      expect(matches, hasLength(1));
      expect(matches.single.playerIds, ['u1']);
      expect(matches.single.startsAt.isBefore(DateTime.now()), isTrue);
    });

    test('orders matches from newest to oldest', () async {
      final older = DateTime.now().subtract(const Duration(days: 5));
      final newer = DateTime.now().subtract(const Duration(days: 1));
      await addMatch(older, ['u1']);
      await addMatch(newer, ['u1']);

      final matches = await repository.watchMyPastMatches('u1').first;

      expect(matches, hasLength(2));
      expect(matches.first.startsAt.isAfter(matches.last.startsAt), isTrue);
    });
  });
}
