import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hexacore_mobile/main.dart';

void main() {
  testWidgets('Validasi login lalu masuk ke Beranda', (WidgetTester tester) async {
    await tester.pumpWidget(const HexacoreApp());

    // Halaman login tampil
    expect(find.text('Hexacore Sparepart'), findsOneWidget);

    // Form kosong -> muncul pesan validasi
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Username wajib diisi'), findsOneWidget);
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);

    // Isi form dengan benar lalu masuk
    await tester.enterText(find.byType(TextFormField).at(0), 'staf');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Beranda tampil
    expect(find.text('Jenis part'), findsOneWidget);
    expect(find.text('Baru datang'), findsOneWidget);
  });
}