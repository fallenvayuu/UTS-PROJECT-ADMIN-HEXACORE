import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> execute({
    required String name,
    required String email,
    required String password,
  }) =>
      repository.register(name: name, email: email, password: password);
}
