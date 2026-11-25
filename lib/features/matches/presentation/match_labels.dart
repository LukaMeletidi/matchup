import 'package:matchup/features/matches/domain/match_enums.dart';
import 'package:matchup/l10n/app_localizations.dart';

String formatLabel(MatchFormat format, AppLocalizations l10n) {
  return switch (format) {
    MatchFormat.sets => l10n.formatSets,
    MatchFormat.tournament => l10n.formatTournament,
  };
}

String kindLabel(MatchKind kind, AppLocalizations l10n) {
  return switch (kind) {
    MatchKind.friendly => l10n.kindFriendly,
    MatchKind.ranked => l10n.kindRanked,
  };
}
