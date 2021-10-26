class UserModel {
  UserModel({required this.id, required this.name, required this.email});

  UserModel.empty()
      : id = 0,
        name = '',
        email = '';

  final int id;
  final String name;
  final String email;
}
