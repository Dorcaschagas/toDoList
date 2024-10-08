import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbslqflite {
  static Dbslqflite _instance = Dbslqflite._internal();

  static Database? _database;

  Dbslqflite._internal();

  factory Dbslqflite() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // String path = join(await getDatabasesPath(), 'toDoList');
    String path = join(await getDatabasesPath(), 'to_do_list');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT,
          descricao TEXT,
          status INTEGER,
          createdAt TEXT,
          prioridade TEXT,
          grupo TEXT
        )
      ''');

        await db.execute('''
          CREATE TABLE grupos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT
          )
        ''');
      },

      // onUpgrade: (db, oldVersion, newVersion) {
      //   if (oldVersion < newVersion) {
      //     // Adicionar a coluna prioridade se ela não existir
      //     db.execute('ALTER TABLE tasks ADD COLUMN grupo TEXT');
      //   }
      // },
    );
  }
}
