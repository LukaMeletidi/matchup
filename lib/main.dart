import 'package:firebase_core/firebase_core.dart';
import 'package:matchup/app.dart';
import 'package:matchup/firebase_options.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MatchUpApp());
}
