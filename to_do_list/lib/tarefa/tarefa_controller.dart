import 'package:flutter/material.dart';
import 'package:to_do_list/data/dbslqflite.dart';
import 'package:to_do_list/tarefa/tarefa_model.dart';

class TarefaController {
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtDescricao = TextEditingController();
  TextEditingController txtDataHora = TextEditingController();

  String txtPrioridade = 'Baixa';
  String sttsSelecionando = 'todos';

  List<TarefaModel> tarefas = [];
  List<TarefaModel> tarefasFiltradas = [];
  
  bool txtStatus = false;
  DateTime? dataSelecionada; 

  void preencherCampos(TarefaModel tarefa) {
    txtNome.text = tarefa.titulo;
    txtDescricao.text = tarefa.descricao;
    txtPrioridade = tarefa.prioridade;
    txtDataHora.text = formatarData(tarefa.createdAt) ;
  }

  String formatarData(DateTime? data) {
    if (data == null) return '';
    final day = data.day.toString().padLeft(2, '0');
    final month = data.month.toString().padLeft(2, '0');
    final year = data.year.toString();
    final hour = data.hour.toString().padLeft(2,'0');
    final min = data.minute.toString().padLeft(2,'0');
    return '$day/$month/$year  $hour:$min';
  }

  Future<void> salvar(BuildContext context) async {
    TarefaModel tarefa = TarefaModel(
      titulo: txtNome.text,
      descricao: txtDescricao.text,
      status: txtStatus,
      prioridade: txtPrioridade,
      createdAt: dataSelecionada 
    );

    if (txtNome.text.isNotEmpty) {
      await Dbslqflite().insertTask(tarefa);
      limparCampos();
      await carregarTarefas(
          sttsSelecionando); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha o título")),
      );
    }
  }

  Future<void> carregarTarefas(String filtroSelecionado) async {
    tarefas = await Dbslqflite().getTask();
    tarefas.sort((a, b) {
      if (b.createdAt == null && a.createdAt == null) return 0;
      if (b.createdAt == null) return 1;
      if (a.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });

    sttsSelecionando = filtroSelecionado;
    filtro(filtroSelecionado);
  }

  Future<void> editarTarefa(TarefaModel tarefa, BuildContext context) async {
    tarefa.titulo = txtNome.text;
    tarefa.descricao = txtDescricao.text;
    tarefa.prioridade = txtPrioridade;
    tarefa.createdAt = dataSelecionada;
    if (txtNome.text.isNotEmpty) {
      await Dbslqflite().updatetask(tarefa);
      limparCampos();
      await carregarTarefas(
          sttsSelecionando); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha o título")),
      );
    }
  }

  Future<void> deletarTarefa(int id) async {
    await Dbslqflite().deletarTaks(id);
    await carregarTarefas(
        sttsSelecionando); 
  }

  Future<void> atualizarStatus(TarefaModel tarefa) async {
    await Dbslqflite().updatetask(tarefa);
    await carregarTarefas(
        sttsSelecionando); 
  }

  void limparCampos() {
    txtNome.clear();
    txtDescricao.clear();
    txtDataHora.clear();
    txtPrioridade = 'Baixa';
    dataSelecionada = null;
  }

  //icones para cada prioridade
  IconData iconePrioridade(String prioridade){
    switch(prioridade){
      case'Baixa':
      return Icons.low_priority;
      case'Media':
      return Icons.priority_high;
      case'Alta':
      return Icons.warning;
      case'todosPri':
      return Icons.help_outline;
      case'todos':
      return Icons.filter_list;
      case'completos':
      return Icons.check_box;
      case'incompletos':
      return Icons.check_box_outline_blank;
      default:
      return Icons.help_outline;
    }
  }

  // Função de filtragem de tarefas
  void filtro(String filtroSelecionado, {DateTime? dataSelecionada, String? prioridadeSelecionada}) {
    //filtro por status
    if (filtroSelecionado == 'todos') {
      tarefasFiltradas = tarefas;
    } else if (filtroSelecionado == 'completos') {
      tarefasFiltradas = tarefas.where((t) => t.status == true).toList();
    } else if (filtroSelecionado == 'incompletos') {
      tarefasFiltradas = tarefas.where((t) => t.status == false).toList();
    }

    //filtro por data 
    if(dataSelecionada != null){
      tarefasFiltradas = tarefasFiltradas.where((t) {
        return t.createdAt != null &&
        t.createdAt!.year == dataSelecionada.year &&
        t.createdAt!.month == dataSelecionada.month &&
        t.createdAt!.day == dataSelecionada.day;
      }).toList();
    }

    // filtro por prioridade
    if(prioridadeSelecionada != null){
      if(prioridadeSelecionada != 'todosPri'){
        tarefasFiltradas = tarefasFiltradas.where((t) => t.prioridade == prioridadeSelecionada).toList();
      } else {
        tarefasFiltradas = tarefas;
      }
    }

  }
}
