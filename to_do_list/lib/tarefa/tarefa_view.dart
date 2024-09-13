import 'package:flutter/material.dart';
import 'package:to_do_list/tarefa/tarefa_controller.dart';

class TarefaView extends StatefulWidget {
  const TarefaView({super.key});

  @override
  State<TarefaView> createState() => _TarefaViewState();
}

class _TarefaViewState extends State<TarefaView> {

  TarefaController controller = TarefaController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        
        children: [
          Column(
            children: [
              TextField(
                decoration: InputDecoration(label: Text("Nome:")),
                controller: controller.txtNome,
              ),
              TextField(
                decoration: InputDecoration(label: Text("Descrição:")),
                controller: controller.txtDescricao,
              ),
              // TextField(
              //   decoration: InputDecoration(label: Text("Nome:")),
              //   controller: controller.txtNome,
              // ),
              ElevatedButton(
                onPressed: () {
                  controller.salvar();
                },
                child: Text("Salvar Tarefa"),
              )
            ],
          ),
          ListView(
            shrinkWrap: true, //fazer ocupar o espaco minimo
            // physics: ,
            children: [
              ListTile(
                  title: Text("primeira"),
                  subtitle: Text("data: 13/09/2024"),
                  trailing: SizedBox(
                    width: 50,
                    height: 10,
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Icon(Icons.delete),
                      ],
                    ),
                  )),
              ListTile(
                  title: Text("primeira"),
                  subtitle: Text("data: 13/09/2024"),
                  trailing: SizedBox(
                    width: 50,
                    height: 10,
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Icon(Icons.delete),
                      ],
                    ),
                  )),
              ListTile(
                  title: Text("primeira"),
                  subtitle: Text("data: 13/09/2024"),
                  trailing: SizedBox(
                    width: 50,
                    height: 10,
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Icon(Icons.delete),
                      ],
                    ),
                  )),
              ListTile(
                  title: Text("primeira"),
                  subtitle: Text("data: 13/09/2024"),
                  trailing: SizedBox(
                    width: 50,
                    height: 10,
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Icon(Icons.delete),
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
