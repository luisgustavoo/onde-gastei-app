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
      'id': userId,
      'name': name,
      'email': email,
    };
  }
}
