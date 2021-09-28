import 'package:firebase_database/firebase_database.dart';

// Class writes to the firebase real time database
class DatabaseService {
  final reference = FirebaseDatabase.instance;
  void writeToDatabase(dynamic latitude, dynamic longitude, dynamic type,
      dynamic description) async {
        reference.reference().child('Markers').push().set({
          'latitude': '$latitude',
          'longitude': '$longitude',
          'description': '$description',
          'type': '$type',
        });
  }
}
