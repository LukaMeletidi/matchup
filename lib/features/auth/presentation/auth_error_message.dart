import 'package:firebase_auth/firebase_auth.dart';
import 'package:matchup/l10n/app_localizations.dart';

String authErrorMessage(Object error, AppLocalizations l10n) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' => l10n.wrongCredentials,
      'email-already-in-use' => l10n.emailInUse,
      'invalid-email' => l10n.invalidEmail,
      _ => l10n.genericError,
    };
  }
  return l10n.genericError;
}
