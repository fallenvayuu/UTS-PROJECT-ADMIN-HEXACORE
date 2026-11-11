import 'package:flutter/material.dart';

import '../../../../core/widgets/common_widgets.dart';
import '../../../auth/presentation/pages/akun_page.dart';
import '../../../buku/presentation/pages/beranda_page.dart';
import '../../../buku/presentation/pages/kategori_page.dart';
import '../../../forum/presentation/pages/forum_page.dart';
import '../../../kios/presentation/pages/denah_page.dart';
import '../../../tentang/presentation/pages/tentang_page.dart';

/// Indeks tab pada bilah navigasi bawah.
class NavTab {
  NavTab._();
  static const beranda = 0;
  static const kategori = 1;
  static const denah = 2;
  static const forum = 3;
  static const tentang = 4;
  static const akun = 5;
}

/// Kerangka utama setelah masuk: 6 tab dengan navigasi bawah.
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = NavTab.beranda;

  void _ke(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _tab,
            children: [
              BerandaPage(onNavigate: _ke),
              KategoriPage(onNavigate: _ke),
              const DenahPage(),
              const ForumPage(),
              const TentangPage(),
              const AkunPage(),
            ],
          ),
        ),
        bottomNavigationBar: WilisBottomNav(index: _tab, onTap: _ke),
      );
}
