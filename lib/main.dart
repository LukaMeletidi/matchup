import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matchup/app.dart';
import 'package:matchup/core/firebase/firebase_emulators.dart';
import 'package:matchup/firebase_options.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    await connectToFirebaseEmulators();
  }
  runApp(const ProviderScope(child: MatchUpApp()));
}
