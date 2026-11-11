import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/post_forum.dart';
import '../viewmodels/forum_viewmodel.dart';

/// Forum Diskusi: tulis postingan, lihat kiriman pengunjung & pedagang, suka, balasan.
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});
  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late final ForumViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = Injection.get<ForumViewModel>();
  }

  Future<void> _buat() async {
    final isi = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _FormBuatPost(),
    );
    if (isi == null || isi.trim().isEmpty || !mounted) return;
    final authVm = Injection.get<AuthViewModel>();
    _vm.buatPost(nama: authVm.currentUser.nama, isi: isi);
    if (!mounted) return;
    pesan(context, 'Postingan terkirim ke Forum Wilis.');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => Container(
          color: AppColors.pageSoft,
          child: Column(children: [
            const WilisHeader(title: 'Forum Diskusi'),
            Expanded(
              child: Stack(children: [
                ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 90), children: [
                  _hero(),
                  const SizedBox(height: 14),
                  _kotakTulis(),
                  const SizedBox(height: 14),
                  for (final p in _vm.posts) Padding(padding: const EdgeInsets.only(bottom: 14), child: _kartuPost(p)),
                ]),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: _buat,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    icon: const Icon(Icons.edit_note),
                    label: Text('Buat Postingan', style: sans(14, weight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      );

  Widget _hero() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.sky200),
          gradient: const LinearGradient(colors: [Color(0xFFE0F2FE), Color(0xFFF1F9FF)]),
        ),
        child: Row(children: [
          const WilisLogo(width: 46),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Forum Diskusi Wilis', style: serif(20, color: AppColors.primaryDark)),
              const SizedBox(height: 2),
              Text('Ruang Titip Cari & Kongkow Literasi Malang', style: sans(12, color: AppColors.primary)),
            ]),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => pesan(context, 'Pencarian forum belum tersedia di prototipe.'),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.search, color: AppColors.muted),
            ),
          ),
        ]),
      );

  Widget _kotakTulis() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.slate200),
        ),
        child: Row(children: [
          const AvatarAsset('assets/images/avatar_saya.png', size: 44),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: _buat,
              child: Container(
                height: 44,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(14)),
                child: Text(
                  'Mulai diskusi atau cari buku...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(13.5, color: AppColors.muted),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _buat,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.sky100, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
            ),
          ),
        ]),
      );

  Widget _kartuPost(PostForum p) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.slate200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AvatarAsset(p.avatar, size: 44),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: serif(17)),
                const SizedBox(height: 3),
                if (p.kios.isNotEmpty)
                  Row(children: [
                    Flexible(child: Pill(p.kios, fontSize: 10, letterSpacing: 0, weight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Text(p.waktu, style: sans(11.5, color: AppColors.muted)),
                  ])
                else
                  Text(p.waktu, style: sans(11.5, color: AppColors.muted)),
              ]),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => pesan(context, 'Menu postingan belum tersedia di prototipe.'),
              child: const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.more_vert, size: 20, color: AppColors.muted)),
            ),
          ]),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(style: sans(14, color: AppColors.ink, height: 1.5), children: _spanKutip(p.isi, sans(14, color: AppColors.ink, height: 1.5))),
          ),
          if (p.gambar.isNotEmpty) ...[const SizedBox(height: 12), _gambar(p.gambar)],
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _aksi(
                p.disukai ? Icons.favorite : Icons.favorite_border,
                '${p.suka} Suka',
                () => _vm.toggleLike(p),
                warna: p.disukai ? AppColors.like : AppColors.ink,
              ),
            ),
            Expanded(
              child: _aksi(
                Icons.chat_bubble_outline,
                '${p.komentar} Komentar',
                () => pesan(context, 'Kolom komentar belum tersedia di prototipe.'),
              ),
            ),
            Expanded(
              child: _aksi(Icons.share_outlined, 'Bagikan', () => pesan(context, 'Tautan postingan disalin (simulasi).')),
            ),
          ]),
          if (p.balasan != null) ...[const SizedBox(height: 12), _balasan(p.balasan!)],
        ]),
      );

  Widget _gambar(List<String> g) {
    if (g.length == 1) return RoundedAsset(g.first, width: double.infinity, height: 200, radius: 14);
    return Row(children: [
      for (var i = 0; i < g.length; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        Expanded(child: RoundedAsset(g[i], height: 170, radius: 12)),
      ],
    ]);
  }

  Widget _aksi(IconData ikon, String teks, VoidCallback aksi, {Color warna = AppColors.ink}) => InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: aksi,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(ikon, size: 20, color: warna),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                teks,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: sans(12.5, weight: FontWeight.w600, color: warna),
              ),
            ),
          ]),
        ),
      );

  Widget _balasan(KomentarForum k) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(14)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarAsset(k.avatar, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
                Text(k.nama, style: serif(16)),
                Pill(k.kios, fontSize: 10, letterSpacing: 0, weight: FontWeight.w600),
              ]),
              const SizedBox(height: 2),
              Text(k.waktu, style: sans(11, color: AppColors.muted)),
              const SizedBox(height: 6),
              Text(k.isi, style: sans(12.5, color: AppColors.body, height: 1.45)),
            ]),
          ),
        ]),
      );

  List<InlineSpan> _spanKutip(String teks, TextStyle dasar) {
    final bagian = teks.split('"');
    final hasil = <InlineSpan>[];
    for (var i = 0; i < bagian.length; i++) {
      final tertutup = i < bagian.length - 1;
      if (i.isOdd && tertutup) {
        hasil.add(TextSpan(text: '"${bagian[i]}"', style: dasar.copyWith(fontStyle: FontStyle.italic)));
      } else if (i.isOdd) {
        hasil.add(TextSpan(text: '"${bagian[i]}'));
      } else if (bagian[i].isNotEmpty) {
        hasil.add(TextSpan(text: bagian[i]));
      }
    }
    return hasil;
  }
}

class _FormBuatPost extends StatefulWidget {
  const _FormBuatPost();
  @override
  State<_FormBuatPost> createState() => _FormBuatPostState();
}

class _FormBuatPostState extends State<_FormBuatPost> {
  final _isi = TextEditingController();

  @override
  void dispose() {
    _isi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Buat Postingan', style: serif(20)),
          const SizedBox(height: 4),
          Text('Titip cari buku atau bagikan temuanmu di Pasar Wilis.', style: sans(12.5, color: AppColors.muted)),
          const SizedBox(height: 14),
          TextField(
            controller: _isi,
            autofocus: true,
            minLines: 4,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            style: sans(14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: 'Tulis di sini...',
              hintStyle: sans(14, color: const Color(0xFF94A3B8)),
              filled: true,
              fillColor: AppColors.sky50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.sky200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.sky200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            text: 'Kirim',
            icon: Icons.send,
            onPressed: _isi.text.trim().isEmpty ? null : () => Navigator.pop(context, _isi.text),
          ),
        ]),
      );
}
