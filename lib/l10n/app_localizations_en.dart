// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MatchUp';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get noAccountYet => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Log in';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get wrongCredentials => 'Wrong email or password';

  @override
  String get emailInUse => 'This email is already registered';

  @override
  String get genericError => 'Something went wrong. Try again.';

  @override
  String get logout => 'Log out';

  @override
  String get profileSetupTitle => 'Create your profile';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameInvalid => 'Nickname must be 3 to 20 characters';

  @override
  String get save => 'Save';

  @override
  String get createMatchTitle => 'New match';

  @override
  String get venue => 'Venue';

  @override
  String get venueInvalid => 'Venue name must be 2 to 60 characters';

  @override
  String get pickDateTime => 'Pick date and time';

  @override
  String get invalidDateTime => 'Pick a date and time in the future';

  @override
  String get createMatch => 'Create match';

  @override
  String get noMatches => 'No upcoming matches yet';
}
