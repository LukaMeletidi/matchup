import 'package:matchup/features/matches/domain/match_exceptions.dart';
import 'package:matchup/l10n/app_localizations.dart';

String matchErrorMessage(Object error, AppLocalizations l10n) {
  return switch (error) {
    MatchFullException() => l10n.matchFull,
    MatchNotFoundException() => l10n.matchNotFound,
    _ => l10n.genericError,
  };
}
