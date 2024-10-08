import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list/model/grupo_model.dart';

class ApiService {
  final String baseUrl =
      'https://dorca3858.c35.integrator.host/toDoList/todoList/';

  //buscar todas as grupos
  Future<List<GrupoModel>> getGrupos() async {
    final response = await http.get(Uri.parse('$baseUrl/gruposs'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => GrupoModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar grupos');
    }
  }

  //criar nova grupo
  Future<void> createGrupo(GrupoModel grupo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/grupos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(grupo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar grupo.');
    }
  }

  // atualizar grupo
  Future<void> updateGrupo(GrupoModel grupo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/grupos/${grupo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(grupo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao atualizar grupo!');
    }
  }

  Future<void> deleteGrupo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/grupos/$id'));
    if (response.statusCode != 201) {
      throw Exception("Erro ao apagar grupo.");
    }
  }
}
