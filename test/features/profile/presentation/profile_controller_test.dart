import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/profile/data/profile_repository.dart';
import 'package:matchup/features/profile/presentation/profile_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockProfileRepository repository;
  late MockUser user;

  setUp(() {
    repository = MockProfileRepository();
    user = MockUser();
    when(() => user.uid).thenReturn('alice');
  });

  ProviderContainer makeContainer({User? signedInUser}) {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        authStateProvider.overrideWith((ref) => Stream.value(signedInUser)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(authStateProvider, (_, _) {});
    return container;
  }

  group('ProfileController', () {
    test('createProfile saves the profile for the signed in user', () async {
      when(
        () => repository.createProfile(
          uid: any(named: 'uid'),
          nickname: any(named: 'nickname'),
        ),
      ).thenAnswer((_) async {});
      final container = makeContainer(signedInUser: user);
      await container.read(authStateProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .createProfile('Alice');

      verify(() => repository.createProfile(uid: 'alice', nickname: 'Alice'))
          .called(1);
      expect(container.read(profileControllerProvider).hasError, isFalse);
    });

    test('createProfile puts the error in state when saving fails', () async {
      when(
        () => repository.createProfile(
          uid: any(named: 'uid'),
          nickname: any(named: 'nickname'),
        ),
      ).thenAnswer((_) async => throw Exception('failed'));
      final container = makeContainer(signedInUser: user);
      await container.read(authStateProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .createProfile('Alice');

      verify(() => repository.createProfile(uid: 'alice', nickname: 'Alice'))
          .called(1);
      expect(container.read(profileControllerProvider).hasError, isTrue);
    });

    test('createProfile does nothing when nobody is signed in', () async {
      final container = makeContainer();
      await container.read(authStateProvider.future);

      await container
          .read(profileControllerProvider.notifier)
          .createProfile('Alice');

      verifyNever(
        () => repository.createProfile(
          uid: any(named: 'uid'),
          nickname: any(named: 'nickname'),
        ),
      );
    });
  });
}
