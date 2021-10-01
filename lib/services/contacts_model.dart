class ContactsModel {
  final String name;
  final String number;
  ContactsModel({required this.name, required this.number});
  ContactsModel.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        number = res["number"];
  Map<String, Object?> toMap() {
    return {'name': name, 'number': number};
  }
}
