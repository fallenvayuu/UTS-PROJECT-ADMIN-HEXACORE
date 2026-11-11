import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../main_shell/presentation/pages/main_shell.dart';
import '../../domain/entities/buku_temuan.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/usecases/get_buku_temuan_usecase.dart';
import '../../domain/usecases/get_kategori_ringkas_usecase.dart';
import '../viewmodels/stok_kategori_viewmodel.dart';

const _ikonKategori = [
  Icons.school_outlined,
  Icons.apartment_outlined,
  Icons.translate,
  Icons.image_outlined,
  Icons.menu_book_outlined,
  Icons.newspaper_outlined,
];

/// Beranda: sambutan, pencarian, kategori pilihan, dan temuan istimewa hari ini.
class BerandaPage extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  const BerandaPage({super.key, required this.onNavigate});
  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final _cari = TextEditingController();
  bool _langka = true;
  late final StokKategoriViewModel _stokVm;
  late final List<KategoriRingkas> _kategoriRingkasList;
  late final List<BukuTemuan> _bukuTemuanList;

  @override
  void initState() {
    super.initState();
    _stokVm = Injection.get<StokKategoriViewModel>();
    _kategoriRingkasList = Injection.get<GetKategoriRingkasUseCase>().execute();
    _bukuTemuanList = Injection.get<GetBukuTemuanUseCase>().execute();
    _stokVm.mulaiPantau();
  }

  @override
  void dispose() {
    _cari.dispose();
    _stokVm.berhenti();
    super.dispose();
  }

  String _eksemplar(KategoriRingkas k) {
    final n = _stokVm.jumlah(k.kategoriApi);
    return n == null ? k.eksemplar : '${formatRibuan(n)} eks';
  }

  String _teksUnggulan() {
    final n = _stokVm.jumlah(const ['Novel']);
    return n == null ? '2.410+ Buku Tersedia' : '${formatRibuan(n)} Buku Tersedia';
  }

  List<BukuTemuan> get _hasil {
    final q = _cari.text.trim().toLowerCase();
    if (q.isEmpty) return _bukuTemuanList;
    return _bukuTemuanList.where((b) => b.judul.toLowerCase().contains(q) || b.penulis.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _stokVm, builder: (context, _) => _isi());

  Widget _isi() => Column(children: [
        const WilisHeader(title: 'Pasar Buku Wilis', subtitle: 'MALANG • SEJAK 1980-AN', titleSize: 18),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _hero(),
              const SizedBox(height: 16),
              _pencarian(),
              const SizedBox(height: 12),
              _filter(),
              const SizedBox(height: 24),
              _judulKategori(),
              const SizedBox(height: 12),
              _kategoriUnggulan(),
              const SizedBox(height: 12),
              _gridKategori(),
              const SizedBox(height: 28),
              Text('Temuan Istimewa Hari Ini', style: sans(18, weight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text('Kurasi langsung dari tumpukan kios Wilis', style: sans(12.5, color: AppColors.muted)),
              const SizedBox(height: 14),
              _temuan(),
            ],
          ),
        ),
      ]);

  Widget _hero() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.sky200),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE6F4FD), Color(0xFFF4FAFF)],
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Pill(
            'Cagar Literasi Malang',
            icon: Icons.check_circle,
            background: Color(0xFFCDE8F8),
            foreground: AppColors.primaryDark,
            fontSize: 12,
            weight: FontWeight.w600,
            letterSpacing: 0,
          ),
          const SizedBox(height: 14),
          Text('Temukan Harta Karun\nPustaka Nusantara', style: serif(24, height: 1.25)),
          const SizedBox(height: 10),
          Text(
            'Lebih dari 60 kios buku antik, literatur langka, dan buku teks tersambung langsung dengan penjual Wilis.',
            style: sans(13.5, color: AppColors.body, height: 1.5),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.sky200),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '58 Kios Buka Hari Ini',
                style: sans(12.5, weight: FontWeight.w700, color: AppColors.ink),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Koleksi Diperbarui: 15 Menit Lalu',
                textAlign: TextAlign.right,
                style: sans(10.5, color: AppColors.muted),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ]),
        ]),
      );

  Widget _pencarian() => Row(children: [
        Expanded(
          child: TextField(
            controller: _cari,
            onChanged: (_) => setState(() {}),
            style: sans(14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: 'Cari judul, pengarang, komik, atau kaset...',
              hintStyle: sans(13.5, color: const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => pesan(context, 'Filter lanjutan belum tersedia di prototipe.'),
                  child: Container(
                    width: 36,
                    decoration: BoxDecoration(color: AppColors.sky100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.tune, size: 20, color: AppColors.primary),
                  ),
                ),
              ),
              filled: true,
              fillColor: AppColors.sky50,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.sky200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.sky200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ]);

  Widget _filter() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          GestureDetector(
            onTap: () => setState(() => _langka = !_langka),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _langka ? AppColors.primary : AppColors.sky50,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _langka ? AppColors.primary : AppColors.sky200),
              ),
              child: Text(
                'Buku Langka',
                style: sans(13, weight: FontWeight.w700, color: _langka ? Colors.white : AppColors.body),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _chipDropdown('Kondisi: Bekas / Baru'),
          const SizedBox(width: 8),
          _chipDropdown('Lokasi Lorong'),
        ]),
      );

  Widget _chipDropdown(String teks) => GestureDetector(
        onTap: () => pesan(context, 'Filter "$teks" belum tersedia di prototipe.'),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
          decoration: BoxDecoration(
            color: AppColors.sky50,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.sky200),
          ),
          child: Row(children: [
            Text(teks, style: sans(13, weight: FontWeight.w500, color: AppColors.body)),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.muted),
          ]),
        ),
      );

  Widget _judulKategori() => Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
        Flexible(
          child: Text(
            'Kategori Pilihan',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: sans(18, weight: FontWeight.w700, color: AppColors.ink),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text('7 Lorong Tematik', style: sans(12.5, color: AppColors.muted))),
        GestureDetector(
          onTap: () => widget.onNavigate(NavTab.kategori),
          child: Text('Lihat Semua ›', style: sans(13, weight: FontWeight.w700, color: AppColors.primary)),
        ),
      ]);

  Widget _kategoriUnggulan() => GestureDetector(
        onTap: () => widget.onNavigate(NavTab.kategori),
        child: SoftCard(
          color: const Color(0xFFEFF7FD),
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Pill(
                  'PALING BANYAK DICARI',
                  background: AppColors.sky200,
                  foreground: AppColors.primaryDark,
                  fontSize: 10,
                  letterSpacing: 0.6,
                ),
                const SizedBox(height: 10),
                Text('Novel & Sastra Klasik', style: sans(18, weight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(
                  'Pramoedya, Mochtar Lubis, Rosihan Anwar',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(12.5, color: AppColors.muted),
                ),
                const SizedBox(height: 10),
                Text(_teksUnggulan(), style: sans(13, weight: FontWeight.w700, color: AppColors.primary)),
              ]),
            ),
            const SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.sky100,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.sky200),
              ),
              child: const Icon(Icons.menu_book_outlined, color: AppColors.primary, size: 26),
            ),
          ]),
        ),
      );

  Widget _gridKategori() => LayoutBuilder(builder: (context, c) {
        final lebar = (c.maxWidth - 12) / 2;
        return Wrap(spacing: 12, runSpacing: 12, children: [
          for (final k in _kategoriRingkasList)
            SizedBox(
              width: lebar,
              child: GestureDetector(
                onTap: () => widget.onNavigate(NavTab.kategori),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.sky200),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      IconBox(icon: _ikonKategori[k.ikon], size: 34),
                      const Spacer(),
                      Text(_eksemplar(k), style: sans(11, color: AppColors.muted)),
                    ]),
                    const SizedBox(height: 10),
                    Text(k.nama, style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(
                      k.contoh,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(11, color: AppColors.muted),
                    ),
                  ]),
                ),
              ),
            ),
        ]);
      });

  Widget _temuan() {
    final data = _hasil;
    if (data.isEmpty) {
      return SoftCard(
        child: Text(
          'Belum ada temuan untuk "${_cari.text.trim()}". Coba kata kunci lain atau tanya di Forum.',
          style: sans(13, color: AppColors.body),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        for (final b in data) Padding(padding: const EdgeInsets.only(right: 12), child: _kartuBuku(b)),
      ]),
    );
  }

  Widget _kartuBuku(BukuTemuan b) => Container(
        width: 162,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.sky200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(b.gambar, width: 162, height: 214, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.info, style: sans(10.5, weight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 4),
              Text(
                b.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink, height: 1.25),
              ),
              const SizedBox(height: 4),
              Text(b.penulis, maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(12, color: AppColors.muted)),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: Text(b.harga, style: sans(13.5, weight: FontWeight.w800, color: AppColors.ink)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(6)),
                  child: Text(b.kios, style: sans(10, weight: FontWeight.w600, color: AppColors.body)),
                ),
              ]),
            ]),
          ),
        ]),
      );
}
