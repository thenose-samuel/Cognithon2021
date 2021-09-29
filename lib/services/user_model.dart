class UserModel {
  final String name;
  final String email;
  UserModel({required this.name, required this.email});
  UserModel.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        email = res["email"];

  Map<String, Object?> toMap() {
    return {'name': name, 'email': email};
  }
}
