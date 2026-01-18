import 'package:flutter/material.dart';

import 'core/firebase/firebase_config.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const BurgerRatsApp());
}

class BurgerRatsApp extends StatelessWidget {
  const BurgerRatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BurgerRats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
