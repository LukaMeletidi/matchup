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

  @override
  String get createMatchTitle => 'ახალი მატჩი';

  @override
  String get venue => 'მოედანი';

  @override
  String get venueInvalid => 'მოედნის სახელი უნდა იყოს 2-დან 60 სიმბოლომდე';

  @override
  String get pickDateTime => 'აირჩიე თარიღი და დრო';

  @override
  String get invalidDateTime => 'აირჩიე მომავალი თარიღი და დრო';

  @override
  String get createMatch => 'მატჩის შექმნა';

  @override
  String get noMatches => 'მომავალი მატჩები ჯერ არ არის';

  @override
  String playersCount(int current, int max) {
    return 'მოთამაშეები: $current/$max';
  }

  @override
  String get matchNotFound => 'ეს მატჩი აღარ არსებობს';

  @override
  String get unknownPlayer => 'მოთამაშე';

  @override
  String get join => 'შეერთება';

  @override
  String get leave => 'გასვლა';

  @override
  String get matchFull => 'მატჩი უკვე სავსეა';

  @override
  String get matchTitle => 'მატჩის სახელი';

  @override
  String get matchTitleInvalid => 'შეიყვანე 3-დან 40 სიმბოლომდე';

  @override
  String get matchFormat => 'ფორმატი';

  @override
  String get formatSets => 'სეტებით';

  @override
  String get formatTournament => 'ტურნირი';

  @override
  String get matchKind => 'ტიპი';

  @override
  String get kindFriendly => 'მეგობრული';

  @override
  String get kindRanked => 'სარეიტინგო';

  @override
  String get pricePerPlayer => 'თანხა მონაწილეზე (₾)';

  @override
  String get priceInvalid => 'შეიყვანე თანხა 0-დან 1000-მდე';

  @override
  String get matchDetailsTitle => 'მატჩის დეტალები';

  @override
  String priceValue(int price) {
    return '$price ₾';
  }

  @override
  String get allDays => 'ყველა';
}
