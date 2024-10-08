import 'package:to_do_list/data/dbslqflite.dart';
import 'package:to_do_list/model/grupo_model.dart';

class GrupoQuerySqlite {
  Future<int> insertGrupo(GrupoModel grupo) async {
    final db = await Dbslqflite().database;
    return db.insert('grupos', grupo.toJson());
  }

  Future<List<GrupoModel>> getGrupo() async {
    final db = await Dbslqflite().database;

    final List<Map<String, dynamic>> maps = await db.query('grupos');
    return List.generate(maps.length, (i) {
      return GrupoModel.fromJson(maps[i]);
    });
  }

  Future<int> deletarTaks(int id) async {
    final db = await Dbslqflite().database;

    return await db.delete('grupos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
