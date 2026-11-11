import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Kolom isian bergaya desain Masuk / Daftar (sudut bulat, border tipis).
class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? action;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.action,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  static OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: w),
      );

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: action,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        style: sans(15, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: sans(15, color: const Color(0xFF94A3B8)),
          suffixIcon: suffix,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          errorStyle: sans(11.5, color: const Color(0xFFDC2626)),
          border: _border(AppColors.border),
          enabledBorder: _border(AppColors.border),
          focusedBorder: _border(AppColors.primary, 1.6),
          errorBorder: _border(const Color(0xFFDC2626)),
          focusedErrorBorder: _border(const Color(0xFFDC2626), 1.6),
        ),
      );
}
