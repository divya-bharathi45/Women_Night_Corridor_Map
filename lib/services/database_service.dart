import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact_model.dart';


class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();

    return _database!;
  }

  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'wncm.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startPlace TEXT,
        destinationPlace TEXT
        )
        ''');
      },
    );
  }

  // ADD CONTACT
  static Future<void> addContact(ContactModel contact) async {
    final db = await database;

    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // GET CONTACTS
  static Future<List<ContactModel>> getContacts() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('contacts');

    return List.generate(maps.length, (i) {
      return ContactModel.fromMap(maps[i]);
    });
  }

  // DELETE CONTACT
  static Future<void> deleteContact(int id) async {
    final db = await database;

    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  // SAVE SEARCH HISTORY
  static Future<void> saveSearch(String start, String destination) async {
    final db = await database;

    await db.insert('history', {
      'startPlace': start,
      'destinationPlace': destination,
    });
  }

  // GET HISTORY
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;

    return await db.query('history', orderBy: 'id DESC');
  }

  // DELETE HISTORY
  static Future<void> deleteHistory(int id) async {

  final db = await database;

  await db.delete(
    "search_history",
    where: "id = ?",
    whereArgs: [id],
  );
}
}
