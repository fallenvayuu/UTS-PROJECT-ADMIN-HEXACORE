import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/daftar_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/main_shell/presentation/pages/main_shell.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String daftar = '/daftar';
  static const String main = '/main';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case daftar:
        return MaterialPageRoute(builder: (_) => const DaftarPage());
      case main:
        return MaterialPageRoute(builder: (_) => const MainShell());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan: ${settings.name}')),
          ),
        );
    }
  }
}
