import 'package:flutter/material.dart';
import 'package:to_do_list/repository/grupo/grupo_api.dart';
import 'package:to_do_list/repository/grupo/grupo_sqlite.dart';
import 'package:to_do_list/model/grupo_model.dart';

class GrupoController {
  final bool usarApi = false;

  dynamic trocarConexao(){
    return usarApi ? GrupoQueryApi() : GrupoQuerySqlite();
  }

  TextEditingController txtGrupo = TextEditingController();

  String? grupoSelecionando;

  // String grupoSelecionando = 'Geral';
  List<GrupoModel> grupos = [];

  VoidCallback? onChange;

  //para editar nome do grupo
  void preencherCampos(GrupoModel grupo) {
    txtGrupo.text = grupo.nome;
  }

  Future<void> salvarGrupo(BuildContext context) async {

    var gruposQuery = trocarConexao();
    GrupoModel grupo = GrupoModel(
      nome: txtGrupo.text,
    );

    if (txtGrupo.text.isNotEmpty) {
      await gruposQuery.insertGrupo(grupo);
      await carregarGrupos();
      txtGrupo.clear();
      if (onChange != null) onChange!(); // Chama o callback
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nome do Grupo Vazio.")),
      );
    }
  }

  Future<void> carregarGrupos() async {
       var gruposQuery = trocarConexao();
    grupos = await gruposQuery.getGrupo();
    if (onChange != null) onChange!(); // Chama o callback
    grupos.sort((a, b) => b.nome.compareTo(a.nome));
  }

  Future<void> apagarGrupo(int id) async {
       var gruposQuery = trocarConexao();
    await gruposQuery.deletarTaks(id);
    await carregarGrupos();
    if (onChange != null) onChange!(); // Chama o callback
  }
}
