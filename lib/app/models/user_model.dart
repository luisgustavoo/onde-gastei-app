// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class UserModel {
  UserModel({
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
  String name;
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
