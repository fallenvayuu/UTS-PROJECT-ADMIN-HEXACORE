import 'package:flutter/material.dart';
import 'app_colors.dart';

const String kSerif = 'PlayfairDisplay';
const String kSans = 'PlusJakartaSans';

/// Gaya teks serif (judul) dan sans (isi).
TextStyle serif(
  double size, {
  FontWeight weight = FontWeight.w700,
  Color color = AppColors.ink,
  FontStyle style = FontStyle.normal,
  double? height,
}) =>
    TextStyle(
      fontFamily: kSerif,
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
      color: color,
      height: height,
    );

TextStyle sans(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = AppColors.body,
  double? height,
  double? letterSpacing,
}) =>
    TextStyle(
      fontFamily: kSans,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      fontFamily: kSans,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary),
      scaffoldBackgroundColor: Colors.white,
      dividerColor: AppColors.slate200,
      splashFactory: InkRipple.splashFactory,
    );
