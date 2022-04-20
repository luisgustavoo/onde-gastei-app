abstract class AuthController {
  Future<void> register(String name, String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();
}
