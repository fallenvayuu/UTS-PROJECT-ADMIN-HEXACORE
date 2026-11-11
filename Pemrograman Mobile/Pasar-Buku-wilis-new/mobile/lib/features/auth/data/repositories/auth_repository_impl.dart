import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  User getCurrentUser() => localDataSource.getCurrentUser();

  @override
  Future<User> loginWithEmail(String email, String password) async =>
      localDataSource.loginWithEmail(email);

  @override
  Future<User> loginWithSocial() async => localDataSource.loginWithSocial();

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async =>
      localDataSource.register(name, email);

  @override
  Future<void> logout() async => localDataSource.logout();
}
