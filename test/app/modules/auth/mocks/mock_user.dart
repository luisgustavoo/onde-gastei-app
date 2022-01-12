import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {
  MockUser({
    String uid = '',
    String? displayName,
    String? email,
  })  : _uid = uid,
        _displayName = displayName,
        _email = email;

  final String _uid;
  final String? _displayName;
  final String? _email;

  @override
  String get uid => _uid;

  @override
  String? get displayName => _displayName;

  @override
  String? get email => _email;
}
