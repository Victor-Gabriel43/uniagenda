class Tarefa {
  final String id;
  final String titulo;
  final String disciplinaId;
  final String data;
  final bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.disciplinaId,
    required this.data,
    this.concluida = false,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      disciplinaId: json['disciplinaId'] as String,
      data: json['data'] as String,
      concluida: json['concluida'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'disciplinaId': disciplinaId,
      'data': data,
      'concluida': concluida,
    };
  }
}
