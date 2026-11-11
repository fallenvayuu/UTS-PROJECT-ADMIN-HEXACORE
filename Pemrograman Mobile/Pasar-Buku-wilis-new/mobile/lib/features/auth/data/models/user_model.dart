import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.nama,
    required super.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nama: json['nama'] as String? ?? 'Pengunjung Wilis',
        email: json['email'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'email': email,
      };
}
