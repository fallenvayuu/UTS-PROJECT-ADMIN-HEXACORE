import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/faq.dart';
import '../../domain/repositories/tentang_repository.dart';

/// Tentang: sejarah paguyuban, lokasi & jam operasional, fasilitas, dan FAQ.
class TentangPage extends StatefulWidget {
  const TentangPage({super.key});
  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  int? _faqBuka = 0;
  late final List<Faq> _faqList;
  late final List<FasilitasPengunjung> _fasilitasList;

  @override
  void initState() {
    super.initState();
    _faqList = Injection.get<GetFaqUseCase>().execute();
    _fasilitasList = Injection.get<GetFasilitasPengunjungUseCase>().execute();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const WilisHeader(title: 'Tentang'),
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), children: [
            _hero(),
            const SizedBox(height: 16),
            _kutipan(),
            const SizedBox(height: 16),
            _sejarah(),
            const SizedBox(height: 24),
            const SectionTitle(icon: Icons.location_on_outlined, text: 'Lokasi dan Operasional'),
            const SizedBox(height: 12),
            _lokasi(),
            const SizedBox(height: 24),
            const SectionTitle(icon: Icons.stairs_outlined, text: 'Fasilitas Pengunjung'),
            const SizedBox(height: 12),
            _fasilitas(),
            const SizedBox(height: 24),
            const SectionTitle(icon: Icons.help_outline, text: 'Pertanyaan Sering Ditanyakan (FAQ)'),
            const SizedBox(height: 12),
            for (var i = 0; i < _faqList.length; i++) Padding(padding: const EdgeInsets.only(bottom: 10), child: _faq(i)),
            const SizedBox(height: 26),
            _penutup(),
          ]),
        ),
      ]);

  Widget _hero() => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 224,
          width: double.infinity,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/images/hero_tentang.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xE6000000)],
                  stops: [0.25, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                const Pill(
                  'SEJAK 1980–AN',
                  icon: Icons.storefront_outlined,
                  background: AppColors.primary,
                  foreground: Colors.white,
                  fontSize: 10.5,
                  letterSpacing: 0.6,
                ),
                const SizedBox(height: 8),
                Text(
                  'Suaka Literasi & Memori Kota Malang',
                  style: sans(20, weight: FontWeight.w600, color: Colors.white, height: 1.2),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pusat buku antik, referensi akademik, dan naskah bersejarah.',
                  style: sans(12.5, color: Colors.white.withAlpha(220), height: 1.35),
                ),
              ]),
            ),
          ]),
        ),
      );

  Widget _kutipan() => Container(
        decoration: BoxDecoration(
          color: AppColors.sky50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.sky200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Container(width: 4, color: AppColors.primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      '“Buku lawas di Wilis bukan sekadar kertas tua; ia adalah saksi perjalanan pemikiran dan memori sejarah kota Malang.”',
                      style: serif(16, weight: FontWeight.w400, style: FontStyle.italic, color: AppColors.primaryDark, height: 1.5),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      Container(width: 14, height: 2, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'ARSIP BUDAYA PAGUYUBAN WILIS',
                          style: sans(10.5, weight: FontWeight.w800, color: AppColors.primary, letterSpacing: 0.8),
                        ),
                      ),
                    ]),
                  ]),
                ),
              ),
            ]),
          ),
        ),
      );

  Widget _sejarah() => SoftCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const IconBox(icon: Icons.history_edu_outlined, size: 40),
            const SizedBox(width: 12),
            Expanded(child: Text('Jejak Sejarah Paguyuban', style: serif(20, color: AppColors.primaryDark))),
          ]),
          const SizedBox(height: 14),
          Text(
            'Pasar Buku Wilis berakar dari dekade 1980-an ketika para pelapak buku emperan di sekeliling Jl. Majapahit dan Alun-Alun Kota Malang direlokasi secara bertahap menuju kawasan Jl. Simpang Wilis Indah.',
            style: sans(13.5, color: AppColors.body, height: 1.55),
          ),
          const SizedBox(height: 12),
          Text(
            'Hingga hari ini, lorong-lorong kayu Wilis menampung lebih dari puluhan kios aktif. Wilis telah menjadi tempat singgah wajib bagi civitas akademika kampus ternama Malang—seperti UB, UM, UIN Maliki, ITN, hingga Unisma—serta jujugan para kolektor sastra dan peneliti naskah Nusantara dari penjuru negeri.',
            style: sans(13.5, color: AppColors.body, height: 1.55),
          ),
        ]),
      );

  Widget _lokasi() => SoftCard(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RoundedAsset('assets/images/peta_wilis.png', width: double.infinity, height: 176, radius: 14),
          const SizedBox(height: 14),
          _baris(
            Icons.notes,
            'Alamat Lengkap',
            'Jl. Simpang Wilis Indah, Kel. Gading Kasri, Kec. Klojen, Kota Malang, Jawa Timur 65115',
          ),
          const SizedBox(height: 12),
          _baris(Icons.schedule, 'Jam Operasional', 'Setiap Hari: 08.00 – 18.00 WIB'),
          const SizedBox(height: 14),
          PrimaryButton(
            text: 'Petunjuk Arah (Maps)',
            icon: Icons.directions_outlined,
            onPressed: () => pesan(context, 'Membuka petunjuk arah ke Pasar Buku Wilis (simulasi).'),
          ),
          const SizedBox(height: 4),
        ]),
      );

  Widget _baris(IconData ikon, String judul, String isi) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconBox(icon: ikon, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(judul, style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(isi, style: sans(12.5, color: AppColors.body, height: 1.45)),
            ]),
          ),
        ]),
      );

  Widget _fasilitas() {
    const ikon = [null, Icons.mosque_outlined, Icons.person_outline];
    return LayoutBuilder(builder: (context, c) {
      final lebar = (c.maxWidth - 12) / 2;
      return Wrap(spacing: 12, runSpacing: 12, children: [
        for (var i = 0; i < _fasilitasList.length; i++)
          SizedBox(
            width: lebar,
            child: SoftCard(
              radius: 16,
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ikon[i] == null ? const IconBox(letter: 'P', size: 38) : IconBox(icon: ikon[i], size: 38),
                const SizedBox(height: 10),
                Text(_fasilitasList[i].nama, style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(_fasilitasList[i].deskripsi, style: sans(12, color: AppColors.muted, height: 1.4)),
              ]),
            ),
          ),
      ]);
    });
  }

  Widget _faq(int i) {
    final f = _faqList[i];
    final buka = _faqBuka == i;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sky50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sky200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _faqBuka = buka ? null : i),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Text(f.tanya, style: sans(13.5, weight: FontWeight.w700, color: AppColors.ink))),
              Icon(buka ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary),
            ]),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: buka
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(height: 1, color: AppColors.sky200),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(f.jawab, style: sans(13, color: AppColors.body, height: 1.5)),
                  ),
                ])
              : const SizedBox(width: double.infinity),
        ),
      ]),
    );
  }

  Widget _penutup() => Column(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.sky100,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.sky200),
          ),
          child: const Icon(Icons.menu_book_outlined, color: AppColors.primary, size: 26),
        ),
        const SizedBox(height: 10),
        Text('Pasar Buku Wilis — Malang', style: serif(17, color: AppColors.primaryDark)),
        const SizedBox(height: 2),
        Text(
          'Merawat Aksara, Menjaga Ingatan Budaya Kota',
          textAlign: TextAlign.center,
          style: sans(12, color: AppColors.muted),
        ),
      ]);
}
