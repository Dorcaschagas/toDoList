import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list/model/tarefas/tarefa_model.dart';

class ApiService {
  final String baseUrl =
      'https://dorca3858.c35.integrator.host/toDoList/todoList/';

  //buscar todas as tarefas
  Future<List<TarefaModel>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tarefass'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => TarefaModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar tarefas');
    }
  }

  //criar nova tarefa
  Future<void> createTask(TarefaModel task) async {
    print(task.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/tarefas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if(response.statusCode != 201){
      throw Exception('Erro ao criar tarefa.');
    }
  }
 
  // atualizar tarefa
  Future<void> updateTask(TarefaModel task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tarefas/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao atualizar tarefa!');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tarefas/$id'));
    if(response.statusCode != 201){
      throw Exception("Erro ao apagar tarefa.");
    }
  }

  // Future<void> executarComando() async {
  //   final String comandoSQL = '''
  //     alter table grupos 
  //     add column teste2 TEXT 
  //   ''';

  //   final response = await http.post(
  //     Uri.parse('$baseUrl/executarcomando'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //     'comando': comandoSQL,  // Estrutura do corpo como objeto JSON
  //     'parametros': []  
  //     }),
  //   );

  //   if(response.statusCode != 200){
  //     throw Exception('Erro ao executar comando.');
  //   }
  // }
}
