import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/core/di/injection.dart';
import 'package:wilis_mobile/core/widgets/common_widgets.dart';
import 'package:wilis_mobile/main.dart';

/// Secara bawaan flutter test memakai font kotak (Ahem), sehingga teks tampak
/// jauh lebih lebar daripada di ponsel dan memicu overflow palsu.
/// Muat font asli aplikasi supaya tata letak di test sama dengan di perangkat.
Future<void> _muatFontAplikasi() async {
  Future<void> muat(String keluarga, List<String> berkas) async {
    final loader = FontLoader(keluarga);
    for (final b in berkas) {
      loader.addFont(rootBundle.load(b));
    }
    await loader.load();
  }

  await muat('PlayfairDisplay', [
    'assets/fonts/PlayfairDisplay-400-normal.ttf',
    'assets/fonts/PlayfairDisplay-400-italic.ttf',
    'assets/fonts/PlayfairDisplay-600-normal.ttf',
    'assets/fonts/PlayfairDisplay-700-normal.ttf',
  ]);
  await muat('PlusJakartaSans', [
    'assets/fonts/PlusJakartaSans-400-normal.ttf',
    'assets/fonts/PlusJakartaSans-500-normal.ttf',
    'assets/fonts/PlusJakartaSans-600-normal.ttf',
    'assets/fonts/PlusJakartaSans-700-normal.ttf',
  ]);
}

/// Ukuran layar ponsel supaya tata letak tidak diuji di layar landscape bawaan test.
void _layarPonsel(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

/// Jalankan splash sampai halaman Masuk tampil.
Future<void> _lewatiSplash(WidgetTester tester) async {
  await tester.pumpWidget(const WilisApp());
  expect(find.text('Pasar Buku Wilis'), findsOneWidget); // teks kaki splash
  await tester.pump(const Duration(milliseconds: 2600));
  await tester.pumpAndSettle();
}

/// Ketuk item pada bilah navigasi bawah (dibatasi di WilisBottomNav agar tidak bentrok dengan judul halaman).
Future<void> _ketukTab(WidgetTester tester, String nama) async {
  await tester.tap(find.descendant(of: find.byType(WilisBottomNav), matching: find.text(nama)));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_muatFontAplikasi);

  setUp(() {
    Injection.init();
  });

  testWidgets('Splash -> Masuk (validasi) -> Beranda -> semua tab', (tester) async {
    _layarPonsel(tester);
    await _lewatiSplash(tester);

    // Halaman Masuk
    expect(find.text('Masuk dengan Google'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi minimal 6 karakter'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'brian@kampus.ac.id');
    await tester.enterText(find.byType(TextFormField).at(1), '123456');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    // Beranda
    expect(find.text('Kategori Pilihan'), findsOneWidget);
    // Bagian ini ada di bawah ListView (dibangun malas), jadi gulir dulu sampai terlihat.
    await tester.scrollUntilVisible(
      find.text('Temuan Istimewa Hari Ini'),
      300,
      scrollable: find.descendant(of: find.byType(ListView).first, matching: find.byType(Scrollable)).first,
    );
    expect(find.text('Temuan Istimewa Hari Ini'), findsOneWidget);

    // Kategori
    await _ketukTab(tester, 'Kategori');
    expect(find.text('Jelajahi Ribuan Lembaran Bersejarah'), findsOneWidget);

    // Denah
    await _ketukTab(tester, 'Denah');
    expect(find.text('Toko Buku Barokah'), findsOneWidget);

    // Forum
    await _ketukTab(tester, 'Forum');
    expect(find.text('Forum Diskusi Wilis'), findsOneWidget);
    expect(find.text('Buat Postingan'), findsOneWidget);

    // Tentang
    await _ketukTab(tester, 'Tentang');
    expect(find.text('Jejak Sejarah Paguyuban'), findsOneWidget);

    // Akun
    await _ketukTab(tester, 'Akun');
    expect(find.text('Keluar'), findsOneWidget);
  });

  testWidgets('Daftar: tombol aktif setelah isian lengkap dan syarat disetujui', (tester) async {
    _layarPonsel(tester);
    await _lewatiSplash(tester);

    await tester.tap(find.text('Daftar')); // tautan "Belum punya akun? Daftar"
    await tester.pumpAndSettle();

    FilledButton tombol() => tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Daftar'));
    expect(tombol().onPressed, isNull); // awalnya nonaktif (abu-abu)

    final kolom = find.byType(TextFormField);
    await tester.enterText(kolom.at(0), 'brian@kampus.ac.id');
    await tester.enterText(kolom.at(1), 'Brian');
    await tester.enterText(kolom.at(2), '123456');
    await tester.enterText(kolom.at(3), '123456');
    await tester.pump();
    expect(tombol().onPressed, isNull); // syarat belum dicentang

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(tombol().onPressed, isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Kategori Pilihan'), findsOneWidget); // langsung ke Beranda
  });
}
