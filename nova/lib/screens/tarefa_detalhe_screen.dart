import 'package:flutter/material.dart';
import '../models/index.dart';

class TarefaDetalheScreen extends StatelessWidget {
  static const routeName = '/tarefa_detalhe';
  final Tarefa tarefa;

  const TarefaDetalheScreen({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarefa.titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Disciplina: ${tarefa.disciplinaId}'),
            const SizedBox(height: 8),
            Text('Data: ${tarefa.data}'),
            const SizedBox(height: 8),
            Text('Concluída: ${tarefa.concluida ? 'Sim' : 'Não'}'),
          ],
        ),
      ),
    );
  }
}
