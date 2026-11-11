import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import 'login_page.dart';

/// Splash screen: logo di tengah, bilah progres, lalu otomatis ke halaman Masuk.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  static const _lebarBar = 176.0;
  late final AnimationController _progres;

  @override
  void initState() {
    super.initState();
    _progres = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _keLogin();
      })
      ..forward();
  }

  void _keLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const LoginPage(),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  void dispose() {
    _progres.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF1F7FF), Colors.white],
              stops: [0.0, 0.45],
            ),
          ),
          child: SafeArea(
            child: Column(children: [
              const Spacer(flex: 11),
              const WilisLogo(width: 130),
              const Spacer(flex: 12),
              AnimatedBuilder(
                animation: _progres,
                builder: (_, __) => Container(
                  width: _lebarBar,
                  height: 4,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6ECF8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    width: _lebarBar * Curves.easeInOut.transform(_progres.value),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(colors: [Color(0xFF1F4CD2), Color(0xFF3549D9)]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 44),
              Text('Pasar Buku Wilis', style: sans(12.5, color: const Color(0xFF8A94A6))),
              const SizedBox(height: 4),
              Text(
                'JALAN SIMPANG WILIS INDAH • MALANG',
                style: sans(9.5, color: const Color(0xFFC1C8D4), letterSpacing: 1.1),
              ),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      );
}
