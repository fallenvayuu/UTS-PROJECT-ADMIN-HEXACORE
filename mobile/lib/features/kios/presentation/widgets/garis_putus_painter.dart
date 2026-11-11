import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Garis putus-putus berbentuk persegi panjang membulat (area lorong pada denah).
class GarisPutusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cat = Paint()
      ..color = AppColors.sky400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final jalur = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
    for (final PathMetric m in jalur.computeMetrics()) {
      double jarak = 0;
      while (jarak < m.length) {
        canvas.drawPath(m.extractPath(jarak, jarak + 6), cat);
        jarak += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
