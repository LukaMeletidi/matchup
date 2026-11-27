import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matchup/features/auth/data/auth_repository.dart';
import 'package:matchup/features/home/home_providers.dart';
import 'package:matchup/features/home/week_strip.dart';
import 'package:matchup/features/matches/presentation/match_card.dart';
import 'package:matchup/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final matches = ref.watch(visibleMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/matches/new'),
        tooltip: l10n.createMatch,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                for (final tab in HomeTab.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(switch (tab) {
                        HomeTab.public => l10n.tabPublic,
                        HomeTab.mine => l10n.tabMine,
                      }),
                      selected: ref.watch(homeTabProvider) == tab,
                      onSelected: (_) =>
                          ref.read(homeTabProvider.notifier).select(tab),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const WeekStrip(),
          const SizedBox(height: 8),
          Expanded(
            child: matches.when(
              error: (error, stack) => Center(child: Text(l10n.genericError)),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (items) => items.isEmpty
                  ? Center(child: Text(l10n.noMatches))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          MatchCard(match: items[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
