import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/tarefa/tarefa_model.dart';

// import '../model/task.dart';
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
    String path = join(await getDatabasesPath(), 'to_do_list');
    return openDatabase(path, version: 2, onCreate: (db, version) {
      return db.execute('''
            CREATE TABLE tasks(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titulo TEXT,
              descricao text,
              status INTEGER,
              createdAt text
            )
          ''');
    },
    onUpgrade: (db, oldVersion, newVersion){
      if(oldVersion < newVersion){
        db.execute('''
          ALTER TABLE tasks ADD COLUMN createdAt TEXT
        '''); 
      }
    }
    );
  }

  Future<int> insertTask(TarefaModel task) async {
    final db = await database;
    return db.insert('tasks', task.toJson());
  }

  Future<List<TarefaModel>> getTask() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TarefaModel.fromJson(maps[i]);
    });
  }

  Future<int> updatetask(TarefaModel task) async {
    final db = await database;

    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }


  Future<int> deletarTaks(int id) async {
    final db = await database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
