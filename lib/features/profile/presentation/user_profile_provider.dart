import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/features/profile/data/profile_repository.dart';
import 'package:matchup/features/profile/domain/user_profile.dart';

final userProfileProvider = StreamProvider.family<UserProfile?, String>(
  (ref, uid) => ref.watch(profileRepositoryProvider).watchProfile(uid),
);
