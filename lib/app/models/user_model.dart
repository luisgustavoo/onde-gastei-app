import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['id_usuario'] as int,
      name: map['nome'] as String,
      email: map['email'] as String,
    );
  }

  final int userId;
  final String name;
  final String email;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_usuario': userId,
      'nome': name,
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => userId.hashCode ^ name.hashCode ^ email.hashCode;
}
