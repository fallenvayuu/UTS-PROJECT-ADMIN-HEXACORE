import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Huruf "G" Google berwarna, digambar manual supaya tidak perlu aset tambahan.
class GoogleG extends StatelessWidget {
  final double size;
  const GoogleG({super.key, this.size = 22});
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _GoogleGPainter()));
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = s * 0.22;
    final r = s * 0.5 - stroke / 2;
    final c = Offset(s / 2, s / 2);
    final rect = Rect.fromCircle(center: c, radius: r);
    double rad(double deg) => deg * math.pi / 180;

    Paint garis(Color warna) => Paint()
      ..color = warna
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, rad(-140), rad(100), false, garis(const Color(0xFFEA4335))); // merah (atas)
    canvas.drawArc(rect, rad(135), rad(85), false, garis(const Color(0xFFFBBC05))); // kuning (kiri)
    canvas.drawArc(rect, rad(45), rad(90), false, garis(const Color(0xFF34A853))); // hijau (bawah)
    canvas.drawArc(rect, rad(0), rad(45), false, garis(const Color(0xFF4285F4))); // biru (kanan bawah)
    // batang horizontal biru
    canvas.drawRect(
      Rect.fromLTRB(s / 2, s / 2 - stroke / 2, s - 0.5, s / 2 + stroke / 2),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
