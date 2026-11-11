import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tombol mata untuk menampilkan / menyembunyikan kata sandi.
class EyeToggle extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;
  const EyeToggle({super.key, required this.visible, required this.onTap});
  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: visible ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi',
        icon: Icon(
          visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.muted,
          size: 22,
        ),
        onPressed: onTap,
      );
}
