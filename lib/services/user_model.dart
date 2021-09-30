class UserModel {
  final String name;
  final String email;
  final String image;
  UserModel({required this.name, required this.email, required this.image});
  UserModel.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        email = res["email"],
        image = res["image"];

  Map<String, Object?> toMap() {
    return {'name': name, 'email': email, 'image': image};
  }
}
