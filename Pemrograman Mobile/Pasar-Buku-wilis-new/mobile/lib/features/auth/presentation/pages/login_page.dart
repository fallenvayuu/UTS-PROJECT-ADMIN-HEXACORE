import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../main_shell/presentation/pages/main_shell.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_field.dart';
import '../widgets/eye_toggle.dart';
import '../widgets/google_g.dart';
import 'daftar_page.dart';

/// Masuk ke aplikasi.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  bool _lihat = false;

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _keBeranda() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  Future<void> _masuk() async {
    if (!_form.currentState!.validate()) return;
    final authVm = Injection.get<AuthViewModel>();
    await authVm.login(_email.text, _sandi.text);
    if (!mounted) return;
    _keBeranda();
  }

  Future<void> _masukSosial() async {
    final authVm = Injection.get<AuthViewModel>();
    await authVm.loginSocial();
    if (!mounted) return;
    _keBeranda();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            const FormHeader(title: 'Masuk'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
                child: Form(
                  key: _form,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Center(child: WilisLogo(width: 142)),
                    const SizedBox(height: 32),
                    AuthField(
                      controller: _email,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      suffix: const Icon(Icons.mail_outline, color: AppColors.muted, size: 22),
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) return 'Format email belum benar';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthField(
                      controller: _sandi,
                      hint: 'Kata Sandi',
                      obscure: !_lihat,
                      action: TextInputAction.done,
                      onSubmitted: (_) => _masuk(),
                      suffix: EyeToggle(visible: _lihat, onTap: () => setState(() => _lihat = !_lihat)),
                      validator: (v) => (v == null || v.length < 6) ? 'Kata sandi minimal 6 karakter' : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => pesan(context, 'Pemulihan kata sandi belum tersedia di prototipe.'),
                        child: Text('Lupa Kata Sandi', style: sans(12.5, weight: FontWeight.w700, color: AppColors.primaryDark)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withAlpha(60),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: PrimaryButton(text: 'Masuk', color: AppColors.primaryDark, onPressed: _masuk),
                    ),
                    const SizedBox(height: 18),
                    Row(children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Atau', style: sans(12.5, color: AppColors.muted)),
                      ),
                      const Expanded(child: Divider()),
                    ]),
                    const SizedBox(height: 18),
                    _TombolSosial(
                      onTap: _masukSosial,
                      leading: const GoogleG(size: 22),
                      text: 'Masuk dengan Google',
                    ),
                    const SizedBox(height: 12),
                    _TombolSosial(
                      onTap: _masukSosial,
                      leading: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(color: AppColors.sky200, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.storefront, size: 16, color: AppColors.primaryDark),
                      ),
                      text: 'Masuk dengan Akun Kios / WhatsApp',
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Belum punya akun? ', style: sans(14, color: AppColors.body)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DaftarPage())),
                          child: Text('Daftar', style: sans(14, weight: FontWeight.w800, color: AppColors.primaryDark)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.muted),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Akses Terpercaya Pengunjung & Paguyuban Kios Wilis',
                            textAlign: TextAlign.center,
                            style: sans(10.5, color: AppColors.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jl. Simpang Wilis Indah, Gading Kasri, Klojen, Kota Malang',
                      textAlign: TextAlign.center,
                      style: sans(9.5, color: const Color(0xFF94A3B8)),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      );
}

class _TombolSosial extends StatelessWidget {
  final VoidCallback onTap;
  final Widget leading;
  final String text;
  const _TombolSosial({required this.onTap, required this.leading, required this.text});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.slate200),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            foregroundColor: AppColors.ink,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            leading,
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: sans(14.5, weight: FontWeight.w600, color: AppColors.ink),
              ),
            ),
          ]),
        ),
      );
}
