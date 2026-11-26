import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/features/home/home_providers.dart';
import 'package:matchup/features/matches/domain/match_enums.dart';
import 'package:matchup/features/matches/domain/sport_match.dart';

SportMatch matchAt(String id, DateTime startsAt) {
  return SportMatch(
    id: id,
    sportId: 'padel',
    organizerId: 'org',
    venueName: 'Club',
    title: 'Game',
    format: MatchFormat.sets,
    kind: MatchKind.friendly,
    pricePerPlayer: 30,
    startsAt: startsAt,
    maxPlayers: 4,
    playerIds: const ['org'],
  );
}

void main() {
  final morning = matchAt('a', DateTime(2030, 5, 10, 9));
  final evening = matchAt('b', DateTime(2030, 5, 10, 20));
  final nextDay = matchAt('c', DateTime(2030, 5, 11, 18));
  final matches = [morning, evening, nextDay];

  group('filterByDay', () {
    test('returns all matches when no day is selected', () {
      expect(filterByDay(matches, null), matches);
    });

    test('keeps only the matches of the selected day', () {
      final result = filterByDay(matches, DateTime(2030, 5, 10));

      expect(result, [morning, evening]);
    });

    test('returns an empty list when the day has no matches', () {
      expect(filterByDay(matches, DateTime(2030, 5, 12)), isEmpty);
    });

    test('isSameDay compares year, month and day', () {
      expect(
        isSameDay(DateTime(2030, 5, 10, 1), DateTime(2030, 5, 10)),
        isTrue,
      );
      expect(isSameDay(DateTime(2030, 5, 10), DateTime(2030, 6, 10)), isFalse);
    });
  });
}
