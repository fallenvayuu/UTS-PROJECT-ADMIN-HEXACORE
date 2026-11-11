import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../main_shell/presentation/pages/main_shell.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_field.dart';
import '../widgets/eye_toggle.dart';

/// Daftar akun baru. Tombol Daftar aktif setelah semua kolom wajib terisi dan syarat disetujui.
class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});
  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _nama = TextEditingController();
  final _sandi = TextEditingController();
  final _ulang = TextEditingController();
  final _referal = TextEditingController();
  bool _lihat = false, _lihatUlang = false, _setuju = false;

  bool get _siap =>
      _setuju &&
      _email.text.trim().isNotEmpty &&
      _nama.text.trim().isNotEmpty &&
      _sandi.text.isNotEmpty &&
      _ulang.text.isNotEmpty;

  @override
  void dispose() {
    _email.dispose();
    _nama.dispose();
    _sandi.dispose();
    _ulang.dispose();
    _referal.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    if (!_form.currentState!.validate()) return;
    final authVm = Injection.get<AuthViewModel>();
    await authVm.register(
      name: _nama.text.trim(),
      email: _email.text.trim(),
      password: _sandi.text,
    );
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  void _ubah(String _) => setState(() {});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            const FormHeader(title: 'Daftar'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Form(
                  key: _form,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const Center(child: WilisLogo(width: 142)),
                    const SizedBox(height: 28),
                    AuthField(
                      controller: _email,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      onChanged: _ubah,
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return 'Email wajib diisi';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) return 'Format email belum benar';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AuthField(
                      controller: _nama,
                      hint: 'Nama Lengkap',
                      action: TextInputAction.next,
                      onChanged: _ubah,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama lengkap wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthField(
                      controller: _sandi,
                      hint: 'Kata Sandi',
                      obscure: !_lihat,
                      action: TextInputAction.next,
                      onChanged: _ubah,
                      suffix: EyeToggle(visible: _lihat, onTap: () => setState(() => _lihat = !_lihat)),
                      validator: (v) => (v == null || v.length < 6) ? 'Kata sandi minimal 6 karakter' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthField(
                      controller: _ulang,
                      hint: 'Konfirmasi Kata Sandi',
                      obscure: !_lihatUlang,
                      action: TextInputAction.next,
                      onChanged: _ubah,
                      suffix: EyeToggle(visible: _lihatUlang, onTap: () => setState(() => _lihatUlang = !_lihatUlang)),
                      validator: (v) => v != _sandi.text ? 'Konfirmasi kata sandi tidak sama' : null,
                    ),
                    const SizedBox(height: 14),
                    AuthField(
                      controller: _referal,
                      hint: 'Kode Referal (Opsional)',
                      action: TextInputAction.done,
                    ),
                    const SizedBox(height: 14),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _setuju,
                          onChanged: (v) => setState(() => _setuju = v ?? false),
                          activeColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primaryDark, width: 1.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: sans(11.5, color: AppColors.body, height: 1.4),
                            children: [
                              const TextSpan(text: 'Dengan mendaftar, kamu menyetujui '),
                              TextSpan(text: 'Syarat & Ketentuan', style: sans(11.5, color: AppColors.primary, height: 1.4)),
                              const TextSpan(text: ' dan '),
                              TextSpan(text: 'Kebijakan Privasi', style: sans(11.5, color: AppColors.primary, height: 1.4)),
                              const TextSpan(text: ' Pasar Buku Wilis'),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    PrimaryButton(text: 'Daftar', onPressed: _siap ? _daftar : null),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('Sudah punya akun? ', style: sans(14, color: AppColors.body)),
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Text(
                            'Masuk',
                            style: sans(14, weight: FontWeight.w800, color: AppColors.ink).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      );
}
