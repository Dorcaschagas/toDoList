import 'package:to_do_list/model/tarefas/tarefa_model.dart';
import 'package:to_do_list/data/dbslqflite.dart';

class TarefasQuerySqlite {
  Future<int> insertTask(TarefaModel task) async {
    final db = await Dbslqflite().database;
    return db.insert('tasks', task.toJson());
  }

  Future<List<TarefaModel>> getTask() async {
    final db = await Dbslqflite().database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TarefaModel.fromJson(maps[i]);
    });
  }

  Future<int> updatetask(TarefaModel task) async {
    final db = await Dbslqflite().database;

    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deletarTaks(int id) async {
    final db = await Dbslqflite().database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}