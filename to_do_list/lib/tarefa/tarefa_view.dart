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
    _focusNodeTitulo.unfocus(); // Remove o foco do título
    _focusNodeDescricao.unfocus(); // Remove o foco da descrição
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
                Navigator.of(context).pop(false); // cancela a exclusão
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // confirma a exclusão
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
              Text(tarefa.descricao),
              SizedBox(height: 16),
              Text("Criado em:"),
              SizedBox(height: 8),
              Text(tarefa.createdAt != null
                  ? controller.formatarData(tarefa.createdAt)
                  : 'Não Disponível'),
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
        title: const Text('To-Do List'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list), // Ícone de filtro
            onSelected: (String filtroSelecionado) {
              _fecharFocus();
              controller.carregarTarefas(filtroSelecionado).then((_) {
                setState(() {});
              });
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
                child: Text('Sem Marcar'),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Remove o foco de qualquer campo
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
                      decoration: InputDecoration(label: Text("Título:")),
                      controller: controller.txtNome,
                      focusNode: _focusNodeTitulo,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: _expandeFormulario ? 130 : 0,
                    child: _expandeFormulario
                        ? Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  label: Text("Descrição:"),
                                ),
                                controller: controller.txtDescricao,
                                focusNode: _focusNodeDescricao,
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
                                        controller.salvar(context).then((_) {});
                                        _fecharFocus();
                                      } else {
                                        controller
                                            .editarTarefa(
                                                tarefaEditada!, context)
                                            .then((_) {
                                          setState(() {
                                            tarefaEditada = null;
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
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    leading: Checkbox(
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
                    title: Text(
                      tarefa.titulo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration:
                            tarefa.status ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            tarefa.descricao,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          tarefa.createdAt != null
                              ? controller.formatarData(tarefa.createdAt)
                              : '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          child: IconButton(
                            // iconSize: 18,
                            onPressed: () {
                              controller.preencherCampos(tarefa);
                              setState(() {
                                tarefaEditada = tarefa;
                                _expandeFormulario =
                                    true; // Garante que o formulário é expandido para edição
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 24,
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
                          width: 24,
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
