


import 'package:to_do_list/data/dbslqflite.dart';
import 'package:to_do_list/tarefa/tarefa_model.dart';

class Controller {
  final Dbslqflite _dbcontroller = Dbslqflite();

  Future<List<TarefaModel>> getAllTasks() async{
    return await _dbcontroller.getTask();
  }


  Future<void> addTask(TarefaModel task) async {
    await _dbcontroller.insertTask(task);
  } 

  Future<void> update(TarefaModel task) async {
    await _dbcontroller.updatetask(task);
  } 

  Future<void> deletaTaks(int id) async {
    await _dbcontroller.deletarTaks(id);
  }
}