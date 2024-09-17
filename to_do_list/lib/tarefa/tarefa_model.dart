class TarefaModel {
  int? id; // pode ser nulo ate que seja editado
  String titulo;
  String descricao;
  bool status;
 DateTime? createdAt;  // data de criacao (opcional)
 String prioridade;

  TarefaModel({
    this.id,
    required this.titulo,
    this.descricao = '',
    this.status = false, // por padrao inicia como false
    this.createdAt, // pode ser inicializada com DateTime.now() ao criar tarefa
    this.prioridade = '',
  }){

    //inicia com a data atual caso n seja definida uma.
    createdAt ??= DateTime.now(); 
  }

//transforma os dados para salvar no banco de dados
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'status': status
          ? 1
          : 0, // converte de bool para int para salvar no banco de dados como numero
      'createdAt': createdAt?.toIso8601String(), // Converte data para string ISO 8601
      'prioridade': prioridade,
    };
  }

// recuper os dados do banco de dados
  factory TarefaModel.fromJson(Map<String, dynamic> json) {
    return TarefaModel(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      status: json['status'] == 1, // transforma de bool para int.
      createdAt:json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      prioridade:json['prioridade'],
    );
  }
}
