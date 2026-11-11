import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> execute(String email, String password) => repository.loginWithEmail(email, password);
  Future<User> executeSocial() => repository.loginWithSocial();
}
