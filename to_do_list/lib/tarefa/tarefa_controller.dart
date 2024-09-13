//funcoes das tarefas vao aqui


import 'package:flutter/material.dart';

class TarefaController {
  TextEditingController txtNome = TextEditingController();
  TextEditingController txtDescricao = TextEditingController();
  bool txtStatus = false;


  salvar(){
    print(txtNome.text);
    print(txtDescricao.text);
    print(txtStatus);
  }
}