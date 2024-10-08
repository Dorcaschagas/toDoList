
import 'package:to_do_list/data/tarefa_api.dart';
import 'package:to_do_list/model/tarefas/tarefa_model.dart';

class TarefasQueryApi {
  final ApiService apiService = ApiService();

  Future<List<TarefaModel>> getTask() async {
    return await apiService.getTasks();
  }

  Future<void> insertTask(TarefaModel task) async {
    return await apiService.createTask(task);
  }

  Future<void> updatetask(TarefaModel task) async {
    await apiService.updateTask(task);
  }

  Future<void> deletarTaks(int id) async {
    await apiService.deleteTask(id);
  }

  // Future<void> executarComando() async {
  //   await apiService.executarComando();
  // }
}
