class UserExistsException implements Exception {
  UserExistsException([this.message]);

  final String? message;
}
