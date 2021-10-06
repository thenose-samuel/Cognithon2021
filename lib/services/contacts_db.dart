import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'contacts_model.dart';


class ContactsHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contacts.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name TEXT NOT NULL,number TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insert(List<ContactsModel> contacts) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var contact in contacts){
      result = await db.insert('contacts', contact.toMap());
    }
    db.close();
    return result;
  }

  Future<List<ContactsModel>> retrieve() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('contacts');
    db.close();
    return queryResult.map((e) => ContactsModel.fromMap(e)).toList();
  }
  Future<void> delete(int id) async {
    final Database db = await initializeDB();
    await db.rawQuery('delete from contacts where number=$id;');    //await db.rawDelete('DELETE FROM contacts WHERE id = $id');
    print("Success");
  }
}