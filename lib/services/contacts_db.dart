import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';

class ContactsHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'contacts.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, number TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insert(List<UserModel> contacts) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var contact in contacts){
      result = await db.insert('contacts', contact.toMap());
    }
    return result;
  }

  Future<List<UserModel>> retrieve() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('contacts');
    return queryResult.map((e) => UserModel.fromMap(e)).toList();
  }
  Future<void> delete(int id) async {
    final db = await initializeDB();
    await db.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}