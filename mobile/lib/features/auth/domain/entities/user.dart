class User {
  final String nama;
  final String email;

  const User({
    required this.nama,
    required this.email,
  });

  bool get isLoggedIn => email.isNotEmpty;

  static const guest = User(
    nama: 'Pengunjung Wilis',
    email: '',
  );
}
