import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final reference = FirebaseDatabase.instance;
  void writeToDatabase(dynamic id, dynamic latitude, dynamic longitude, dynamic type,
      dynamic description) async {
        reference.reference().child('Markers').push().set({
          'latitude': '$latitude',
          'longitude': '$longitude',
          'description': '$description',
          'type': '$type',
        });
  }
}
