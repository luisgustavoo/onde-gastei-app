abstract class AuthRepository {
  Future<void> register(String name, String email, String password);
}
