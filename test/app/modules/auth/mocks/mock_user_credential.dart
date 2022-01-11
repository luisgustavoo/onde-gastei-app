import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_user.dart';

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential({User? mockUser}) : _user = mockUser;

  final User? _user;

  @override
  User? get user => _user;
}
