import 'package:flutter/material.dart';
import 'package:to_do_list/tarefa/tarefa_controller.dart';
import 'package:to_do_list/tarefa/tarefa_model.dart';

class TarefaView extends StatefulWidget {
  const TarefaView({super.key});

  @override
  State<TarefaView> createState() => _TarefaViewState();
}

class _TarefaViewState extends State<TarefaView> {
  TarefaController controller = TarefaController();
  TarefaModel? tarefaEditada;
  bool _expandeFormulario = false;
  final _focusNodeTitulo = FocusNode();
  final _focusNodeDescricao = FocusNode();
  final _focusNodeDatahora = FocusNode();
  final _focusNodePrioridade = FocusNode();
  String _iconeprioridade = 'Baixa';
  String _iconeCheckbox = 'todos';
  bool _editando = false;

  @override
  void initState() {
    super.initState();
    controller.carregarTarefas('todos').then((_) {
      setState(() {});
    });

    _focusNodeTitulo.addListener(() {
      if (_focusNodeTitulo.hasFocus) {
        setState(() {
          _expandeFormulario = true;
        });
      }
    });
  }

  void _fecharFocus() {
    _focusNodeTitulo.unfocus();
    _focusNodeDescricao.unfocus();
    _focusNodeDatahora.unfocus();
    _focusNodePrioridade.unfocus();
    setState(() {
      _expandeFormulario = false;
    });
  }

  Future<void> _confirmaDelecao(TarefaModel tarefa) async {
    bool? confirmar = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Exclusão?"),
          content: Text("Tem certeza que deseja excluir?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await controller.deletarTarefa(tarefa.id!);
      setState(() {});
    }
  }

  void _mostrarMaisDetalhes(TarefaModel tarefa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tarefa.titulo),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Descrição:"),
              SizedBox(height: 8),
              Text(
                tarefa.descricao,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text('Prioridade:'),
              SizedBox(height: 8),
              Text(
                tarefa.prioridade,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text("Criado em:"),
              SizedBox(height: 8),
              Text(
                  tarefa.createdAt != null
                      ? controller.formatarData(tarefa.createdAt)
                      : 'Não Disponível',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciador de Tarefas',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: _editando
                ? null
                : () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(
                        () {
                          DateTime dataFiltro = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                          );
                          controller.filtro(
                            controller.sttsSelecionando,
                            dataSelecionada: dataFiltro,
                            prioridadeSelecionada: controller.txtPrioridade,
                          );
                        },
                      );
                    }
                  },
            icon: Icon(Icons.calendar_today),
            disabledColor: Colors.grey,
          ),
          PopupMenuButton<String>(
            icon: Icon(controller
                .iconePrioridade(_iconeprioridade)), 
            onSelected: _editando
                ? null
                : (String prioridade) {
                    _fecharFocus();
                    setState(() {
                      _iconeprioridade = prioridade;
                      controller.filtro(controller.sttsSelecionando,
                          dataSelecionada: controller.dataSelecionada,
                          prioridadeSelecionada: prioridade);
                    });
                  },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'todosPri',
                child: Text('Todos'),
              ),
              const PopupMenuItem<String>(
                value: 'Baixa',
                child: Text('Baixa'),
              ),
              const PopupMenuItem<String>(
                value: 'Media',
                child: Text('Média'),
              ),
              const PopupMenuItem<String>(
                value: 'Alta',
                child: Text('Alta'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(
                controller.iconePrioridade(_iconeCheckbox)), 
            onSelected: _editando
                ? null
                : (String filtroSelecionado) {
                    _fecharFocus();
                    controller.carregarTarefas(filtroSelecionado).then((_) {
                      setState(() {
                        _iconeCheckbox = filtroSelecionado;
                      });
                    });
                    // setState(() {
                    //   controller.filtro(filtroSelecionado, dataSelecionada:  controller.dataSelecionada, prioridadeSelecionada: controller.txtPrioridade);
                    //   _iconeCheckbox = filtroSelecionado;
                    // });
                  },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'todos',
                child: Text('Todos'),
              ),
              const PopupMenuItem<String>(
                value: 'completos',
                child: Text('Marcados'),
              ),
              const PopupMenuItem<String>(
                value: 'incompletos',
                child: Text('Abertos'),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); 
          _fecharFocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandeFormulario = true;
                      });
                      FocusScope.of(context).requestFocus(_focusNodeTitulo);
                    },
                    child: TextField(
                      decoration: InputDecoration(
                          label: Text(
                        "Título:",
                        style: TextStyle(fontSize: 12),
                      )),
                      controller: controller.txtNome,
                      focusNode: _focusNodeTitulo,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: _expandeFormulario ? 240 : 0,
                    child: _expandeFormulario
                        ? Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  label: Text("Descrição:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                controller: controller.txtDescricao,
                                focusNode: _focusNodeDescricao,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  label: Text("Data e Hora:",
                                      style: TextStyle(fontSize: 12)),
                                  hintText: controller.txtDataHora.text.isEmpty
                                      ? "Selecione Data e Hora"
                                      : controller.txtDataHora.text,
                                ),
                                readOnly: true,
                                controller: controller.txtDataHora,
                                focusNode: _focusNodeDatahora,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      setState(
                                        () {
                                          controller.dataSelecionada = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          controller.txtDataHora.text =
                                              controller.formatarData(
                                                  controller.dataSelecionada!);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  label: Text("Prioridade:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                value: controller.txtPrioridade,
                                items: <String>['Baixa', 'Media', 'Alta']
                                    .map((String valor) {
                                  return DropdownMenuItem<String>(
                                    child: Text(valor,
                                        style: TextStyle(fontSize: 12)),
                                    value: valor,
                                  );
                                }).toList(),
                                onChanged: (String? novoValor) {
                                  setState(() {
                                    controller.txtPrioridade = novoValor!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  tarefaEditada != null
                                      ? TextButton(
                                          onPressed: () {
                                            _fecharFocus();
                                            controller.limparCampos();
                                            tarefaEditada = null;
                                            _editando = false;
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey[400],
                                          ),
                                          child: Text("Calcelar",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      if (tarefaEditada == null) {
                                        controller.salvar(context).then((_) {
                                          setState(() {});
                                        });
                                        setState(() {
                                          _fecharFocus();
                                        });
                                      } else {
                                        controller
                                            .editarTarefa(
                                                tarefaEditada!, context)
                                            .then((_) {
                                          setState(() {
                                            _fecharFocus();
                                            tarefaEditada = null;
                                            _editando = false;
                                          });
                                        });
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 67, 116, 207),
                                    ),
                                    child: Text(
                                        tarefaEditada != null
                                            ? "Salvar Edição"
                                            : "Salvar Tarefa",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.tarefasFiltradas.length,
                itemBuilder: (context, index) {
                  TarefaModel tarefa = controller.tarefasFiltradas[index];
                  if (tarefaEditada != null && tarefa.id == tarefaEditada!.id) {
                    return SizedBox.shrink();
                  }
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    padding: EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius:
                          BorderRadius.circular(8.0), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2), 
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      leading: SizedBox(
                        width: 24,
                        child: Checkbox(
                          value: tarefa.status,
                          onChanged: (bool? value) {
                            setState(() {
                              tarefa.status = value!;
                            });
                            controller.atualizarStatus(tarefa).then((_) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                      title: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarefa.titulo,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: tarefa.status
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tarefa.createdAt != null
                                    ? controller.formatarData(tarefa.createdAt)
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                    color: tarefa.prioridade == 'Baixa'
                                        ? Colors.green[100]
                                        : tarefa.prioridade == 'Media'
                                            ? Colors.amber[400]
                                            : tarefa.prioridade == 'Alta'
                                                ? Colors.red[400]
                                                : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: tarefa.prioridade == 'Baixa'
                                          ? Colors
                                              .green 
                                          : tarefa.prioridade == 'Média'
                                              ? Colors
                                                  .amber 
                                              : tarefa.prioridade == 'Alta'
                                                  ? Colors
                                                      .red 
                                                  : Colors
                                                      .grey, 
                                      width: 1.0,
                                    )),
                                child: Text(
                                  tarefa.prioridade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              tarefa.descricao,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                          // SizedBox(width: 8),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              // iconSize: 18,
                              onPressed: () {
                                controller.preencherCampos(tarefa);
                                setState(() {
                                  tarefaEditada = tarefa;
                                  _editando = true;
                                  _expandeFormulario =
                                      true; 
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              // iconSize: 18,
                              onPressed: () {
                                _confirmaDelecao(tarefa);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 30,
                            child: IconButton(
                              // iconSize: 18,
                              onPressed: () {
                                _mostrarMaisDetalhes(tarefa);
                              },
                              icon: Icon(Icons.info),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
