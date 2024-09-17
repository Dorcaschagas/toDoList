# To-Do List App
Este é um aplicativo de Gerenciar tarefas (To-Do List) desenvolvido com Flutter e SQLite (sqflite) para persistência de dados.

## Funcionalidades
 - Adicionar Tarefa: Crie novas tarefas com título, descrição, prioridade e data/hora de criação.
 - Editar Tarefa: Edite os detalhes das tarefas existentes.
 - Excluir Tarefa: Remova tarefas da lista.
 - Filtrar Tarefas: Filtre as tarefas por status (completas, incompletas) ou prioridade (Baixa, Média, Alta).
 - Atualizar Status: Marque as tarefas como completas ou incompletas.

## Estrutura do Projeto
 - tarefa_controller.dart: Controlador que gerencia as funcionalidades de criar, editar, excluir e filtrar as tarefas.
 - tarefa_model.dart: Modelo de dados das tarefas, incluindo métodos para converter as tarefas em JSON e vice-versa.
 - dbSqlflite.dart: Gerenciamento do banco de dados SQLite, com funções para criar o banco, inserir, atualizar e deletar tarefas.

## Como usar
 - Clone o repositório:

```bash
    git clone https://github.com/Dorcaschagas/toDoList.git
```
### Instale as dependências:
```bash
    flutter pub get
```

### Execute o aplicativo:
```bash
    flutter run
 ```

### Tecnologias Utilizadas
 - Flutter: Para o desenvolvimento da interface de usuário.
 - SQLite (sqflite): Para persistência local de dados.
