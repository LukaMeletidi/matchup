import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/features/profile/data/profile_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProfileRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = ProfileRepository(firestore);
  });

  group('ProfileRepository', () {
    test('watchProfile emits null when the profile does not exist', () async {
      final profile = await repository.watchProfile('alice').first;

      expect(profile, isNull);
    });

    test('watchProfile emits the profile when it exists', () async {
      await firestore.collection('users').doc('alice').set({
        'nickname': 'Alice',
      });
      final profile = await repository.watchProfile('alice').first;

      expect(profile?.uid, 'alice');
      expect(profile?.nickname, 'Alice');
    });

    test('createProfile saves the nickname and a creation time', () async {
      await repository.createProfile(uid: 'alice', nickname: 'Alice');
      final doc = await firestore.collection('users').doc('alice').get();

      expect(doc.data()?['nickname'], 'Alice');
      expect(doc.data()?['createdAt'], isA<Timestamp>());
    });
  });
}
