import 'package:material_ui/material_ui.dart';

class MatchUpApp extends StatelessWidget {
  const MatchUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MatchUp',
      home: Scaffold(body: Center(child: Text('MatchUp'))),
    );
  }
}
