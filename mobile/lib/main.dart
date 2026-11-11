import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';

/// Alur layar: Splash Screen -> Masuk -> (Daftar) -> Beranda
/// Setelah masuk ada 6 tab: Beranda, Kategori, Denah, Forum, Tentang, Akun.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Injection.init();
  runApp(const WilisApp());
}

class WilisApp extends StatelessWidget {
  const WilisApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pasar Buku Wilis',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const SplashPage(),
      );
}
