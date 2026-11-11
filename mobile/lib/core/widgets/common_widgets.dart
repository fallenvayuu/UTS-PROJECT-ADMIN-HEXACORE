import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Logo Pasar Buku Wilis (aset hasil potong dari desain).
class WilisLogo extends StatelessWidget {
  final double width;
  const WilisLogo({super.key, this.width = 140});
  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/logo.png',
        width: width,
        fit: BoxFit.contain,
        semanticLabel: 'Logo Pasar Buku Wilis',
      );
}

/// Header halaman utama: logo + judul serif + ikon simpan & notifikasi.
class WilisHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double titleSize;
  const WilisHeader({super.key, required this.title, this.subtitle, this.titleSize = 20});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.slate200)),
        ),
        child: Row(children: [
          const WilisLogo(width: 44),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: serif(titleSize), maxLines: 1, overflow: TextOverflow.ellipsis),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: sans(10, weight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.8),
                ),
            ]),
          ),
          IconButton(
            tooltip: 'Tersimpan',
            icon: const Icon(Icons.bookmark_border, color: AppColors.ink),
            onPressed: () => pesan(context, 'Daftar buku tersimpan belum tersedia di prototipe.'),
          ),
          IconButton(
            tooltip: 'Notifikasi',
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none, color: AppColors.ink),
              Positioned(
                right: 1,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                ),
              ),
            ]),
            onPressed: () => pesan(context, 'Belum ada notifikasi baru.'),
          ),
        ]),
      );
}

/// Header halaman form (Masuk / Daftar): tombol kembali + judul.
class FormHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const FormHeader({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.slate200)),
        ),
        child: Row(children: [
          IconButton(
            tooltip: 'Kembali',
            icon: const Icon(Icons.arrow_back, color: AppColors.ink),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 4),
          Text(title, style: sans(18, weight: FontWeight.w700, color: AppColors.ink)),
        ]),
      );
}

/// Judul bagian: ikon kecil + teks serif.
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  const SectionTitle({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: serif(20, color: AppColors.primaryDark))),
      ]);
}

/// Label kecil berbentuk pil.
class Pill extends StatelessWidget {
  final String text;
  final Color background, foreground;
  final IconData? icon;
  final double fontSize;
  final FontWeight weight;
  final double letterSpacing;
  const Pill(
    this.text, {
    super.key,
    this.background = AppColors.sky100,
    this.foreground = AppColors.primary,
    this.icon,
    this.fontSize = 11,
    this.weight = FontWeight.w700,
    this.letterSpacing = 0.3,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: fontSize + 3, color: foreground), const SizedBox(width: 4)],
          Flexible(
            child: Text(
              text,
              style: sans(fontSize, weight: weight, color: foreground, letterSpacing: letterSpacing),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]),
      );
}

/// Kartu lembut biru muda dengan border tipis.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final double radius;
  final double borderWidth;
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.sky50,
    this.borderColor = AppColors.sky200,
    this.radius = 20,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: child,
      );
}

/// Kotak ikon kecil (latar biru muda).
class IconBox extends StatelessWidget {
  final IconData? icon;
  final String? letter;
  final double size;
  const IconBox({super.key, this.icon, this.letter, this.size = 40});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.sky100, borderRadius: BorderRadius.circular(12)),
        child: icon != null
            ? Icon(icon, color: AppColors.primary, size: size * 0.55)
            : Text(letter ?? '', style: sans(size * 0.45, weight: FontWeight.w800, color: AppColors.primary)),
      );
}

/// Tombol biru penuh (aksi utama di Denah & Tentang).
class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: color,
      disabledBackgroundColor: AppColors.disabled,
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: sans(15, weight: FontWeight.w700),
    );
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: icon == null
          ? FilledButton(onPressed: onPressed, style: style, child: Text(text))
          : FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: 18),
              label: Text(text),
            ),
    );
  }
}

/// Snackbar singkat.
void pesan(BuildContext context, String teks) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(
    content: Text(teks, style: sans(13, color: Colors.white)),
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.ink,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 2),
  ));
}

/// Gambar aset dengan sudut membulat.
class RoundedAsset extends StatelessWidget {
  final String asset;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  const RoundedAsset(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(asset, width: width, height: height, fit: fit),
      );
}

/// Avatar bulat dari aset.
class AvatarAsset extends StatelessWidget {
  final String asset;
  final double size;
  const AvatarAsset(this.asset, {super.key, this.size = 44});
  @override
  Widget build(BuildContext context) => ClipOval(
        child: Image.asset(asset, width: size, height: size, fit: BoxFit.cover),
      );
}

/// Bilah navigasi bawah: Beranda, Kategori, Denah, Forum, Tentang, Akun.
class WilisBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const WilisBottomNav({super.key, required this.index, required this.onTap});

  static const _item = [
    (Icons.home_outlined, Icons.home, 'Beranda'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Kategori'),
    (Icons.map_outlined, Icons.map, 'Denah'),
    (Icons.forum_outlined, Icons.forum, 'Forum'),
    (Icons.info_outline, Icons.info, 'Tentang'),
    (Icons.person_outline, Icons.person, 'Akun'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.slate200)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(children: [
              for (var i = 0; i < _item.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(
                        i == index ? _item[i].$2 : _item[i].$1,
                        size: 24,
                        color: i == index ? AppColors.primary : AppColors.muted,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _item[i].$3,
                        style: sans(
                          10.5,
                          weight: i == index ? FontWeight.w700 : FontWeight.w500,
                          color: i == index ? AppColors.primary : AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 22,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: i == index ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ]),
                  ),
                ),
            ]),
          ),
        ),
      );
}
