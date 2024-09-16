import 'package:flutter/material.dart';
import 'package:to_do_list/data/dbslqflite.dart';
import 'package:to_do_list/tarefa/tarefa_model.dart';

class TarefaController {
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtDescricao = TextEditingController();
  bool txtStatus = false;
  String sttsSelecionando = 'todos'; 

  List<TarefaModel> tarefas = [];
  List<TarefaModel> tarefasFiltradas = [];

  // Preencher campos para editar.
  void preencherCampos(TarefaModel tarefa) {
    txtNome.text = tarefa.titulo;
    txtDescricao.text = tarefa.descricao;
  }

  String formatarData(DateTime? data) {
    if (data == null) return '';
    final day = data.day.toString().padLeft(2, '0');
    final month = data.month.toString().padLeft(2, '0');
    final year = data.year.toString();
    return '$day/$month/$year';
  }

  Future<void> salvar(BuildContext context) async {
    TarefaModel tarefa = TarefaModel(
      titulo: txtNome.text,
      descricao: txtDescricao.text,
      status: txtStatus,
    );
    if (txtNome.text.isNotEmpty) {
      await Dbslqflite().insertTask(tarefa);
      limparCampos();
      await carregarTarefas(sttsSelecionando); // Recarrega as tarefas após salvar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha o título")),
      );
    }
  }

  Future<void> carregarTarefas(String filtroSelecionado ) async {
    tarefas = await Dbslqflite().getTask();
    sttsSelecionando = filtroSelecionado;
    filtro(filtroSelecionado);  // Aplica o filtro
  }

  Future<void> editarTarefa(TarefaModel tarefa, BuildContext context) async {
    tarefa.titulo = txtNome.text;
    tarefa.descricao = txtDescricao.text;
    print(tarefa.status);

    if (txtNome.text.isNotEmpty) {
      await Dbslqflite().updatetask(tarefa);
      limparCampos();
      await carregarTarefas(sttsSelecionando);  // Recarrega as tarefas após edição
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha o título")),
      );
    }
  }

  Future<void> deletarTarefa(int id) async {
    await Dbslqflite().deletarTaks(id);
    await carregarTarefas(sttsSelecionando);  // Recarrega as tarefas após exclusão
  }

  Future<void> atualizarStatus(TarefaModel tarefa) async {
    await Dbslqflite().updatetask(tarefa);
    await carregarTarefas(sttsSelecionando);  // Recarrega as tarefas após atualização do status
  }

  void limparCampos() {
    txtNome.clear();
    txtDescricao.clear();
  }

  // Função de filtragem de tarefas
  void filtro(String filtroSelecionado) {
    if (filtroSelecionado == 'todos') {
      tarefasFiltradas = tarefas;
    } else if (filtroSelecionado == 'completos') {
      tarefasFiltradas = tarefas.where((t) => t.status == true).toList();
    } else if (filtroSelecionado == 'incompletos') {
      tarefasFiltradas = tarefas.where((t) => t.status == false).toList();
    }
    print('Filtro aplicado: $filtroSelecionado');
  }
}
