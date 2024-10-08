class GrupoModel {
  int? id;
  String nome;
  GrupoModel({
    this.id,
    required this.nome,
  });

//transforma para o banco de dados
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  //recebe do banco de dados
  factory GrupoModel.fromJson(Map<String, dynamic> json){
    return GrupoModel(
      id: json['id'],
      nome: json['nome'],
    );
  }
}
