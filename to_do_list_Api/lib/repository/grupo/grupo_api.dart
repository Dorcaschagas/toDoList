
import 'package:to_do_list/data/grupo_api.dart';
import 'package:to_do_list/model/grupo_model.dart';

class GrupoQueryApi {
  final ApiService apiService = ApiService();

  Future<List<GrupoModel>> getGrupo() async {
    return await apiService.getGrupos();
  }

  Future<void> insertGrupo(GrupoModel grupo) async {
    return await apiService.createGrupo(grupo);
  }

  Future<void> updatetask(GrupoModel grupo) async {
    await apiService.updateGrupo(grupo);
  }

  Future<void> deletarTaks(int id) async {
    await apiService.deleteGrupo(id);
  }
}
