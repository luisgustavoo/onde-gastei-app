abstract class AuthController {
  Future<bool> isLogged();

  Future<void> register(String name, String email, String password);
}
