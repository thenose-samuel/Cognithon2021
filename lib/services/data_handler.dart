import 'package:firebase_database/firebase_database.dart';

// Class writes to the firebase real time database
class DatabaseService {
  final reference = FirebaseDatabase.instance;
  Future<void> writeToDatabase(dynamic latitude, dynamic longitude, dynamic rating,
      dynamic description) async {
        reference.reference().child('Markers').push().set({
          'latitude': '$latitude',
          'longitude': '$longitude',
          'description': '$description',
          'rating': '$rating',
        });
  }
}
