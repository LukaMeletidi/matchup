// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appTitle => 'MatchUp';

  @override
  String get login => 'შესვლა';

  @override
  String get signUp => 'რეგისტრაცია';

  @override
  String get email => 'ელფოსტა';

  @override
  String get password => 'პაროლი';

  @override
  String get noAccountYet => 'ჯერ არ გაქვს ანგარიში? დარეგისტრირდი';

  @override
  String get haveAccount => 'უკვე გაქვს ანგარიში? შედი';

  @override
  String get invalidEmail => 'შეიყვანე სწორი ელფოსტა';

  @override
  String get passwordTooShort => 'პაროლი უნდა იყოს მინიმუმ 6 სიმბოლო';

  @override
  String get wrongCredentials => 'ელფოსტა ან პაროლი არასწორია';

  @override
  String get emailInUse => 'ეს ელფოსტა უკვე დარეგისტრირებულია';

  @override
  String get genericError => 'რაღაც შეცდომა მოხდა. სცადე თავიდან.';

  @override
  String get logout => 'გასვლა';

  @override
  String get profileSetupTitle => 'შექმენი პროფილი';

  @override
  String get nickname => 'მეტსახელი';

  @override
  String get nicknameInvalid => 'მეტსახელი უნდა იყოს 3-დან 20 სიმბოლომდე';

  @override
  String get save => 'შენახვა';
}
