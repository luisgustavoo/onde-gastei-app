class UserNotFoundException implements Exception {
  UserNotFoundException({this.message});

  final String? message;
}
