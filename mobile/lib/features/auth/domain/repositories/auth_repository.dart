import '../entities/user.dart';

abstract class AuthRepository {
  User getCurrentUser();
  Future<User> loginWithEmail(String email, String password);
  Future<User> loginWithSocial();
  Future<User> register({required String name, required String email, required String password});
  Future<void> logout();
}
