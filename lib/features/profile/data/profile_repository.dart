import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/core/firebase/firebase_providers.dart';
import 'package:matchup/features/profile/domain/user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  Stream<UserProfile?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return UserProfile(
        uid: snapshot.id,
        nickname: data['nickname'] as String,
      );
    });
  }

  Future<void> createProfile({required String uid, required String nickname}) {
    return _doc(uid)
        .set({'nickname': nickname, 'createdAt': FieldValue.serverTimestamp()});
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(firestoreProvider)),
);
