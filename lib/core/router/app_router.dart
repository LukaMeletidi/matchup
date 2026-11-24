import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matchup/features/auth/presentation/auth_state_provider.dart';
import 'package:matchup/features/auth/presentation/login_screen.dart';
import 'package:matchup/features/home/home_screen.dart';
import 'package:matchup/features/matches/presentation/create_match_screen.dart';
import 'package:matchup/features/matches/presentation/match_details_screen.dart';
import 'package:matchup/features/profile/presentation/current_profile_provider.dart';
import 'package:matchup/features/profile/presentation/profile_setup_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(currentProfileProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null;

      final location = state.matchedLocation;

      if (auth.value == null) {
        return location == '/login' ? null : '/login';
      }

      final profile = ref.read(currentProfileProvider);
      if (profile.isLoading) return null;

      if (profile.value == null) {
        return location == '/profile-setup' ? null : '/profile-setup';
      }

      if (location == '/login' || location == '/profile-setup') return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/matches/new',
        builder: (context, state) => const CreateMatchScreen(),
      ),
      GoRoute(
        path: '/matches/:id',
        builder: ((context, state) =>
            MatchDetailsScreen(matchId: state.pathParameters['id']!)),
      ),
    ],
  );
});
