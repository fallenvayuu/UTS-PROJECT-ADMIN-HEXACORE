import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../main_shell/presentation/pages/main_shell.dart';
import '../../domain/entities/kategori.dart';
import '../../domain/usecases/get_kategori_tematik_usecase.dart';
import '../viewmodels/stok_kategori_viewmodel.dart';
import 'kategori_detail_page.dart';

/// Kategori Buku: jelajah tema, filter kondisi fisik, dan daftar lorong.
class KategoriPage extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  const KategoriPage({super.key, required this.onNavigate});
  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  static const _tab = ['Semua', 'Paling Populer', 'Buku Langka/Koleksi'];
  static const _populer = {'KLASIK', 'STUDI', 'POPULER', 'PESANTREN'};
  static const _langka = {'AKADEMIK', 'PERIODIK', 'LANGKA', 'PESANTREN'};

  int _tabAktif = 0;
  final _kondisi = <int>{0, 2};
  late final StokKategoriViewModel _stokVm;
  late final List<KategoriTematik> _kategoriTematikList;

  @override
  void initState() {
    super.initState();
    _stokVm = Injection.get<StokKategoriViewModel>();
    _kategoriTematikList = Injection.get<GetKategoriTematikUseCase>().execute();
    _stokVm.mulaiPantau();
  }

  @override
  void dispose() {
    _stokVm.berhenti();
    super.dispose();
  }

  String _jumlah(KategoriTematik k) {
    final n = _stokVm.jumlah(k.kategoriApi);
    return n == null ? k.jumlah : '${formatRibuan(n)} ${k.satuan}';
  }

  List<KategoriTematik> get _daftar {
    switch (_tabAktif) {
      case 1:
        return _kategoriTematikList.where((k) => _populer.contains(k.label)).toList();
      case 2:
        return _kategoriTematikList.where((k) => _langka.contains(k.label)).toList();
      default:
        return _kategoriTematikList;
    }
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _stokVm, builder: (context, _) => _isi());

  Widget _isi() {
    final daftar = _daftar;
    return Column(children: [
      const WilisHeader(title: 'Kategori Buku'),
      Expanded(
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
          Row(children: [
            const Pill(
              'ARSIP WILIS',
              background: AppColors.primary,
              foreground: Colors.white,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
            const SizedBox(width: 10),
            Text('Malang, Jawa Timur', style: sans(12.5, color: AppColors.muted)),
          ]),
          const SizedBox(height: 12),
          Text('Jelajahi Ribuan Lembaran Bersejarah', style: serif(28, height: 1.15)),
          const SizedBox(height: 8),
          Text(
            'Pilah berdasarkan tema, selusuri lorong kios pedagang pasar buku legendaris.',
            style: sans(13.5, color: AppColors.body, height: 1.45),
          ),
          const SizedBox(height: 16),
          _tabChips(),
          const SizedBox(height: 16),
          _filterKondisi(),
          const SizedBox(height: 16),
          _kartuInfo(),
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: Text('Kategori Tematik', style: serif(22))),
            Text('${daftar.length} Kategori Pilihan', style: sans(12, weight: FontWeight.w700, color: AppColors.primary)),
          ]),
          const SizedBox(height: 14),
          if (!_stokVm.termuat && _stokVm.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Server belum terhubung, jumlah buku masih angka contoh.',
                style: sans(11.5, color: AppColors.muted),
              ),
            ),
          for (final k in daftar) Padding(padding: const EdgeInsets.only(bottom: 12), child: _kartuKategori(k)),
          const SizedBox(height: 12),
          _catatan(),
        ]),
      ),
    ]);
  }

  Widget _tabChips() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (var i = 0; i < _tab.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _tabAktif = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: i == _tabAktif ? AppColors.primary : AppColors.sky50,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: i == _tabAktif ? AppColors.primary : AppColors.sky200),
                  ),
                  child: Text(
                    _tab[i],
                    style: sans(
                      13,
                      weight: FontWeight.w700,
                      color: i == _tabAktif ? Colors.white : AppColors.body,
                    ),
                  ),
                ),
              ),
            ),
        ]),
      );

  Widget _filterKondisi() {
    const opsi = [
      ('Bekas Berkualitas', null),
      ('Naskah Bersejarah', Icons.menu_book_outlined),
      ('Baru & Segel', null),
    ];
    return SoftCard(
      radius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
              'PILIH KONDISI FISIK',
              style: sans(11, weight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.8),
            ),
          ),
          const Icon(Icons.filter_alt_outlined, size: 20, color: AppColors.primary),
        ]),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (var i = 0; i < opsi.length; i++)
            GestureDetector(
              onTap: () => setState(() => _kondisi.contains(i) ? _kondisi.remove(i) : _kondisi.add(i)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _kondisi.contains(i) ? AppColors.sky100 : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kondisi.contains(i) ? AppColors.primary : AppColors.sky200),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  if (_kondisi.contains(i))
                    const Icon(Icons.check, size: 16, color: AppColors.primary)
                  else if (opsi[i].$2 != null)
                    Icon(opsi[i].$2, size: 16, color: AppColors.muted),
                  if (_kondisi.contains(i) || opsi[i].$2 != null) const SizedBox(width: 6),
                  Text(
                    opsi[i].$1,
                    style: sans(
                      12.5,
                      weight: FontWeight.w600,
                      color: _kondisi.contains(i) ? AppColors.primaryDark : AppColors.body,
                    ),
                  ),
                ]),
              ),
            ),
        ]),
      ]),
    );
  }

  Widget _kartuInfo() => SoftCard(
        radius: 16,
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const IconBox(icon: Icons.person_pin_circle_outlined, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Cari koleksi spesifik di lorong mana?', style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(
                'Tanyakan di forum komunitas atau langsung hubungi paguyuban kios Wilis.',
                style: sans(12, color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 10),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 10, children: [
                GestureDetector(
                  onTap: () => widget.onNavigate(NavTab.forum),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Tanya Forum', style: sans(12.5, weight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                  ]),
                ),
                const Icon(Icons.circle, size: 4, color: AppColors.sky400),
                GestureDetector(
                  onTap: () => widget.onNavigate(NavTab.denah),
                  child: Text('Cek Denah Kios', style: sans(12.5, weight: FontWeight.w700, color: AppColors.muted)),
                ),
              ]),
            ]),
          ),
        ]),
      );

  Widget _kartuKategori(KategoriTematik k) => GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => KategoriDetailPage(kategori: k))),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.sky200),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              RoundedAsset(k.gambar, width: 96, height: 98, radius: 12),
              Positioned(
                left: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    k.label,
                    style: sans(8.5, weight: FontWeight.w800, color: AppColors.ink, letterSpacing: 0.4),
                  ),
                ),
              ),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Pill(_jumlah(k), fontSize: 10.5, letterSpacing: 0),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 22, color: AppColors.muted),
                ]),
                const SizedBox(height: 6),
                Text(k.nama, style: sans(15, weight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(k.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(11.5, color: AppColors.muted)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.apartment_outlined, size: 15, color: AppColors.primary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      k.lorong,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: sans(11.5, weight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      );

  Widget _catatan() => SoftCard(
        radius: 18,
        padding: const EdgeInsets.all(18),
        child: Stack(children: [
          const Positioned(right: 0, top: 0, child: Icon(Icons.format_quote, size: 36, color: AppColors.sky200)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.format_quote, size: 20, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'CATATAN PEDAGANG WILIS',
                style: sans(11.5, weight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.8),
              ),
            ]),
            const SizedBox(height: 10),
            Text(
              '"Setiap lorong punya rahasianya sendiri. Kalau tidak menemukan judul yang kamu cari di etalase depan, mintalah penjual untuk merogoh tumpukan bagian belakang."',
              style: sans(13.5, color: AppColors.body, height: 1.5).copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text('— Pak De Kios 14, Sesepuh Wilis', style: sans(12.5, weight: FontWeight.w700, color: AppColors.primaryDark)),
          ]),
        ]),
      );
}
