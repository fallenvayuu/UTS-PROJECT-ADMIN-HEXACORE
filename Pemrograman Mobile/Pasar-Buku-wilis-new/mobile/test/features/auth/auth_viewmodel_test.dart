import 'package:flutter_test/flutter_test.dart';
import 'package:wilis_mobile/core/utils/api_exception.dart';
import 'package:wilis_mobile/features/auth/domain/entities/user.dart';
import 'package:wilis_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:wilis_mobile/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:wilis_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:wilis_mobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wilis_mobile/features/auth/domain/usecases/register_usecase.dart';
import 'package:wilis_mobile/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// Repository palsu: user aktif disimpan di memori, kegagalan bisa dipicu dari test.
class _RepoPalsu implements AuthRepository {
  User pengguna = User.guest;
  Object? galat;
  String? emailTerakhir;
  String? passwordTerakhir;
  String? namaTerakhir;

  @override
  User getCurrentUser() => pengguna;

  @override
  Future<User> loginWithEmail(String email, String password) async {
    emailTerakhir = email;
    passwordTerakhir = password;
    if (galat != null) throw galat!;
    return pengguna = User(nama: 'Budi', email: email);
  }

  @override
  Future<User> loginWithSocial() async {
    if (galat != null) throw galat!;
    return pengguna = const User(nama: 'Google User', email: 'g@mail.com');
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    namaTerakhir = name;
    emailTerakhir = email;
    if (galat != null) throw galat!;
    return pengguna = User(nama: name, email: email);
  }

  @override
  Future<void> logout() async {
    pengguna = User.guest;
  }
}

void main() {
  late _RepoPalsu repo;
  late AuthViewModel vm;

  setUp(() {
    repo = _RepoPalsu();
    vm = AuthViewModel(
      loginUseCase: LoginUseCase(repo),
      registerUseCase: RegisterUseCase(repo),
      logoutUseCase: LogoutUseCase(repo),
      getCurrentUserUseCase: GetCurrentUserUseCase(repo),
    );
  });

  tearDown(() => vm.dispose());

  test('keadaan awal: pengguna tamu, tidak memuat, tanpa error', () {
    expect(vm.currentUser.isLoggedIn, isFalse);
    expect(vm.currentUser.nama, 'Pengunjung Wilis');
    expect(vm.isLoading, isFalse);
    expect(vm.errorMessage, isNull);
  });

  test('login sukses: mengembalikan true dan pengguna terisi', () async {
    final ok = await vm.login('budi@mail.com', 'rahasia');

    expect(ok, isTrue);
    expect(vm.currentUser.email, 'budi@mail.com');
    expect(vm.currentUser.isLoggedIn, isTrue);
    expect(vm.isLoading, isFalse);
    expect(vm.errorMessage, isNull);
    expect(repo.emailTerakhir, 'budi@mail.com');
    expect(repo.passwordTerakhir, 'rahasia');
  });

  test('login: status memuat menyala lalu mati', () async {
    final status = <bool>[];
    vm.addListener(() => status.add(vm.isLoading));

    await vm.login('budi@mail.com', 'rahasia');

    expect(status, [true, false]);
  });

  test('login gagal: false, pesan error terisi, pengguna tetap tamu', () async {
    repo.galat = const ApiException('Email atau kata sandi salah');

    final ok = await vm.login('budi@mail.com', 'salah');

    expect(ok, isFalse);
    expect(vm.errorMessage, 'Email atau kata sandi salah');
    expect(vm.isLoading, isFalse);
    expect(vm.currentUser.isLoggedIn, isFalse);
  });

  test('error lama dibersihkan saat percobaan berikutnya sukses', () async {
    repo.galat = const ApiException('Gagal');
    await vm.login('budi@mail.com', 'salah');
    expect(vm.errorMessage, isNotNull);

    repo.galat = null;
    final ok = await vm.login('budi@mail.com', 'benar');

    expect(ok, isTrue);
    expect(vm.errorMessage, isNull);
  });

  test('loginSocial sukses dan gagal', () async {
    expect(await vm.loginSocial(), isTrue);
    expect(vm.currentUser.nama, 'Google User');

    repo.galat = const ApiException('Login Google dibatalkan');
    expect(await vm.loginSocial(), isFalse);
    expect(vm.errorMessage, 'Login Google dibatalkan');
    expect(vm.isLoading, isFalse);
  });

  test('register sukses: data diteruskan ke repository dan pengguna terisi', () async {
    final ok = await vm.register(name: 'Sari', email: 'sari@mail.com', password: 'abc12345');

    expect(ok, isTrue);
    expect(vm.currentUser.nama, 'Sari');
    expect(repo.namaTerakhir, 'Sari');
    expect(repo.emailTerakhir, 'sari@mail.com');
    expect(vm.errorMessage, isNull);
  });

  test('register gagal: false dan pesan error terisi', () async {
    repo.galat = const ApiException('Email sudah terdaftar');

    final ok = await vm.register(name: 'Sari', email: 'sari@mail.com', password: 'abc12345');

    expect(ok, isFalse);
    expect(vm.errorMessage, 'Email sudah terdaftar');
    expect(vm.currentUser.isLoggedIn, isFalse);
  });

  test('logout: kembali menjadi pengunjung dan listener dikabari', () async {
    await vm.login('budi@mail.com', 'rahasia');
    var dikabari = 0;
    vm.addListener(() => dikabari++);

    await vm.logout();

    expect(vm.currentUser.isLoggedIn, isFalse);
    expect(vm.currentUser.nama, 'Pengunjung Wilis');
    expect(dikabari, 1);
  });
}
