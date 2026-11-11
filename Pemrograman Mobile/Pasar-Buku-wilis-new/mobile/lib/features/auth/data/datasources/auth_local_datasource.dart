import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  UserModel getCurrentUser();
  UserModel loginWithEmail(String email);
  UserModel loginWithSocial();
  UserModel register(String name, String email);
  void logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  String _nama = 'Pengunjung Wilis';
  String _email = '';

  @override
  UserModel getCurrentUser() => UserModel(nama: _nama, email: _email);

  @override
  UserModel loginWithEmail(String email) {
    _email = email.trim();
    if (_nama == 'Pengunjung Wilis' && _email.contains('@')) {
      final depan = _email.split('@').first;
      if (depan.isNotEmpty) _nama = depan[0].toUpperCase() + depan.substring(1);
    }
    return getCurrentUser();
  }

  @override
  UserModel loginWithSocial() {
    _email = '';
    return getCurrentUser();
  }

  @override
  UserModel register(String name, String email) {
    _nama = name.trim();
    _email = email.trim();
    return getCurrentUser();
  }

  @override
  void logout() {
    _nama = 'Pengunjung Wilis';
    _email = '';
  }
}
