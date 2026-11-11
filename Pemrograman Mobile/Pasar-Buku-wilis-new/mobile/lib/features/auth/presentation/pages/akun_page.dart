import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';

/// Akun: profil singkat dan tombol keluar.
class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  Future<void> _keluar(BuildContext context) async {
    final authVm = Injection.get<AuthViewModel>();
    await authVm.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Injection.get<AuthViewModel>();

    const menu = [
      (Icons.bookmark_border, 'Buku Tersimpan'),
      (Icons.notifications_none, 'Notifikasi'),
      (Icons.support_agent, 'Hubungi Paguyuban Kios'),
      (Icons.privacy_tip_outlined, 'Kebijakan Privasi'),
    ];

    return ListenableBuilder(
      listenable: authVm,
      builder: (context, _) {
        final user = authVm.currentUser;
        return Column(children: [
          const WilisHeader(title: 'Akun'),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(16, 24, 16, 24), children: [
              const Center(child: AvatarAsset('assets/images/avatar_saya.png', size: 88)),
              const SizedBox(height: 12),
              Center(child: Text(user.nama, style: serif(22))),
              if (user.email.isNotEmpty) ...[
                const SizedBox(height: 2),
                Center(child: Text(user.email, style: sans(13, color: AppColors.muted))),
              ],
              const SizedBox(height: 24),
              SoftCard(
                radius: 18,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(children: [
                  for (var i = 0; i < menu.length; i++) ...[
                    if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.sky200),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(menu[i].$1, color: AppColors.primary),
                        title: Text(menu[i].$2, style: sans(14, weight: FontWeight.w600, color: AppColors.ink)),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
                        onTap: () => pesan(context, '${menu[i].$2} belum tersedia di prototipe.'),
                      ),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => _keluar(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.like,
                    side: const BorderSide(color: AppColors.like),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: Text('Keluar', style: sans(14.5, weight: FontWeight.w700, color: AppColors.like)),
                ),
              ),
            ]),
          ),
        ]);
      },
    );
  }
}
