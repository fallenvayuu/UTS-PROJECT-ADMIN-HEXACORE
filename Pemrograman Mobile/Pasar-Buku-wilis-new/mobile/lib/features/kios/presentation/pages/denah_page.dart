import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/kios.dart';
import '../viewmodels/denah_viewmodel.dart';
import '../widgets/garis_putus_painter.dart';

/// Denah & Peta Kios: cari kios, lihat denah, detail kios terpilih, dan fasilitas publik.
class DenahPage extends StatefulWidget {
  const DenahPage({super.key});
  @override
  State<DenahPage> createState() => _DenahPageState();
}

class _DenahPageState extends State<DenahPage> {
  final _cari = TextEditingController(text: 'Kios A-04');
  late final DenahViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = Injection.get<DenahViewModel>();
  }

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => Container(
          color: AppColors.pageSoft,
          child: Column(children: [
            const WilisHeader(title: 'Denah & Peta Kios'),
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
                _pencarian(),
                if (_vm.tidakDitemukan)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text('Kios tidak ditemukan. Coba kode seperti A-01 atau nama kios.', style: sans(12, color: AppColors.like)),
                  ),
                const SizedBox(height: 12),
                _status(),
                const SizedBox(height: 14),
                _denah(),
                const SizedBox(height: 14),
                _detail(_vm.kiosTerpilih),
                const SizedBox(height: 24),
                Text('Fasilitas Publik Pasar Wilis', style: serif(19)),
                const SizedBox(height: 12),
                _fasilitas(),
              ]),
            ),
          ]),
        ),
      );

  Widget _pencarian() => TextField(
        controller: _cari,
        onChanged: _vm.cariKios,
        textInputAction: TextInputAction.search,
        style: sans(15, weight: FontWeight.w500, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: 'Cari kode atau nama kios...',
          hintStyle: sans(14, color: const Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search, color: AppColors.muted),
          suffixIcon: _cari.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Hapus',
                  icon: const Icon(Icons.cancel, color: AppColors.border),
                  onPressed: () {
                    _cari.clear();
                    _vm.cariKios('');
                  },
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.sky200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.sky200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      );

  Widget _status() => SoftCard(
        radius: 16,
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Pasar Sedang Ramai', style: sans(14, weight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(width: 8),
            const Pill('58 Kios Buka', background: AppColors.greenSoft, foreground: AppColors.green, fontSize: 11),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Operasional: 08.30 – 20.00 WIB • 6 Kios Tutup',
                style: sans(12, color: AppColors.body),
              ),
            ),
          ]),
        ]),
      );

  // ---------- Denah ----------
  Widget _denah() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.sky200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.explore_outlined, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Expanded(child: Text('Denah Pasar', style: serif(18))),
            _kontrolZoom(),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sky50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.sky200),
            ),
            child: LayoutBuilder(builder: (context, c) {
              final lebarIsi = c.maxWidth * _vm.zoom;
              final lebarSel = (lebarIsi - 3 * 8) / 4;
              final tinggiSel = 54.0 * _vm.zoom;
              Widget baris(int mulai) => Row(children: [
                    for (var i = mulai; i < mulai + 4; i++)
                      Padding(
                        padding: EdgeInsets.only(right: i == mulai + 3 ? 0 : 8),
                        child: _sel(i, lebarSel, tinggiSel),
                      ),
                  ]);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: lebarIsi,
                  child: Column(children: [
                    const SizedBox(height: 8),
                    baris(0),
                    const SizedBox(height: 12),
                    CustomPaint(
                      painter: GarisPutusPainter(),
                      child: SizedBox(
                        width: double.infinity,
                        height: 42 * _vm.zoom,
                        child: Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.sky200.withAlpha(140),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(color: AppColors.sky400, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    baris(4),
                  ]),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 16, runSpacing: 6, children: [
            _legenda('Kios Terpilih', AppColors.primary, AppColors.primary),
            _legenda('Kios Buka', Colors.white, AppColors.sky200),
            _legenda('Tutup / Libur', AppColors.slate200, AppColors.slate200),
          ]),
        ]),
      );

  Widget _kontrolZoom() => Container(
        decoration: BoxDecoration(
          color: AppColors.sky50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.sky200),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _tombolZoom(Icons.zoom_in, 'Perbesar', () => _vm.ubahZoom(_vm.zoom + 0.2)),
          Container(width: 1, height: 20, color: AppColors.sky200),
          _tombolZoom(Icons.zoom_out, 'Perkecil', () => _vm.ubahZoom(_vm.zoom - 0.2)),
          Container(width: 1, height: 20, color: AppColors.sky200),
          _tombolZoom(Icons.fullscreen, 'Atur ulang', () => _vm.ubahZoom(1.0)),
        ]),
      );

  Widget _tombolZoom(IconData ikon, String tip, VoidCallback aksi) => InkWell(
        onTap: aksi,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(ikon, size: 20, color: AppColors.primary, semanticLabel: tip),
        ),
      );

  Widget _sel(int i, double lebar, double tinggi) {
    final k = _vm.daftarKios[i];
    final dipilih = i == _vm.terpilih;
    final warnaIsi = dipilih ? AppColors.primary : (k.buka ? Colors.white : AppColors.slate200);
    final warnaTeks = dipilih ? Colors.white : (k.buka ? AppColors.ink : AppColors.muted);
    return GestureDetector(
      onTap: () {
        _vm.setTerpilih(i);
        _cari.text = 'Kios ${k.kode}';
      },
      child: SizedBox(
        width: lebar,
        height: tinggi + 6,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned.fill(
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: warnaIsi,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: dipilih ? AppColors.sky400 : (k.buka ? AppColors.sky200 : AppColors.slate200), width: dipilih ? 2 : 1),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(k.kode, style: sans(13, weight: FontWeight.w800, color: warnaTeks)),
                const SizedBox(height: 2),
                Text(
                  k.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(9.5, color: dipilih ? Colors.white70 : AppColors.muted),
                ),
              ]),
            ),
          ),
          if (dipilih)
            Positioned(
              right: -2,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.amber, borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(color: k.buka ? AppColors.green : AppColors.like, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 3),
                  Text(k.buka ? 'Buka' : 'Tutup', style: sans(8.5, weight: FontWeight.w800, color: AppColors.ink)),
                ]),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _legenda(String teks, Color isi, Color garis) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: isi, borderRadius: BorderRadius.circular(4), border: Border.all(color: garis)),
        ),
        const SizedBox(width: 6),
        Text(teks, style: sans(11.5, color: AppColors.body)),
      ]);

  // ---------- Detail kios ----------
  Widget _detail(Kios k) {
    final tersimpan = _vm.isDisimpan(k.kode);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sky400, width: 2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Pill('Kios ${k.kode}', background: AppColors.primary, foreground: Colors.white, fontSize: 12, letterSpacing: 0),
          const SizedBox(width: 8),
          Flexible(
            child: Pill(
              k.buka ? 'Buka (Tutup ${k.tutup})' : 'Tutup',
              icon: Icons.schedule,
              background: k.buka ? AppColors.greenSoft : AppColors.slate200,
              foreground: k.buka ? AppColors.green : AppColors.muted,
              fontSize: 11.5,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: tersimpan ? 'Hapus dari tersimpan' : 'Simpan kios',
            visualDensity: VisualDensity.compact,
            icon: Icon(tersimpan ? Icons.bookmark : Icons.bookmark_border, color: AppColors.muted),
            onPressed: () => _vm.toggleSimpan(k.kode),
          ),
        ]),
        const SizedBox(height: 8),
        Text(k.nama.startsWith('Toko') ? k.nama : 'Toko Buku ${k.nama}', style: serif(24, height: 1.2)),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.person_outline, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(k.pemilik, style: sans(12.5, color: AppColors.body, height: 1.4))),
        ]),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.sky50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.sky200),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'KOLEKSI SPESIALISASI KIOS',
              style: sans(10.5, weight: FontWeight.w800, color: AppColors.primaryDark, letterSpacing: 0.8),
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final s in k.spesialisasi)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.sky200),
                  ),
                  child: Text(s, style: sans(12.5, weight: FontWeight.w500, color: AppColors.ink)),
                ),
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.sky200),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text('Jumlah Arsip Terdata :', style: sans(12.5, color: AppColors.muted))),
              Text(k.jumlahArsip, style: sans(15, weight: FontWeight.w800, color: AppColors.primary)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Text('Buku Terpopuler di Stan Ini', style: serif(16))),
          GestureDetector(
            onTap: () => pesan(context, 'Daftar lengkap buku kios ${k.kode} belum tersedia di prototipe.'),
            child: Text('Lihat Semua', style: sans(12.5, weight: FontWeight.w700, color: AppColors.primary)),
          ),
        ]),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final b in _vm.bukuPopuler)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 104,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.sky200),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    RoundedAsset(b.gambar, width: 94, height: 108, radius: 10),
                    const SizedBox(height: 6),
                    Text(
                      b.judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(12, weight: FontWeight.w700, color: AppColors.ink),
                    ),
                    Text(b.penulis, maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(10.5, color: AppColors.muted)),
                  ]),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 14),
        PrimaryButton(
          text: 'Hubungi Penjual',
          icon: Icons.chat_bubble_outline,
          onPressed: () => pesan(context, 'Menghubungi penjual kios ${k.kode} (simulasi).'),
        ),
      ]),
    );
  }

  // ---------- Fasilitas ----------
  Widget _fasilitas() {
    const ikon = [null, Icons.mosque_outlined, Icons.wc];
    return LayoutBuilder(builder: (context, c) {
      final lebar = (c.maxWidth - 12) / 2;
      return Wrap(spacing: 12, runSpacing: 12, children: [
        for (var i = 0; i < _vm.fasilitasPublik.length; i++)
          SizedBox(
            width: lebar,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.sky200),
              ),
              child: Row(children: [
                ikon[i] == null ? const IconBox(letter: 'P', size: 40) : IconBox(icon: ikon[i], size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_vm.fasilitasPublik[i].nama, style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(_vm.fasilitasPublik[i].lokasi, style: sans(11, color: AppColors.muted, height: 1.3)),
                  ]),
                ),
              ]),
            ),
          ),
      ]);
    });
  }
}
