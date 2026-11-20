import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/core/router/app_router.dart';
import 'package:material_ui/material_ui.dart';

class MatchUpApp extends ConsumerWidget{
  const MatchUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MatchUp',
      routerConfig: router,
    );
  }
}
