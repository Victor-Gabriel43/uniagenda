import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../utils/index.dart';

class CalendarioScreen extends StatelessWidget {
  const CalendarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefas = StorageService.instance.tarefas;
    final tarefasOrdenadas = [...tarefas]..sort((a, b) => a.data.compareTo(b.data));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calendário', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: tarefasOrdenadas.isEmpty
                ? const Center(child: Text('Nenhuma atividade cadastrada.'))
                : ListView.builder(
                    itemCount: tarefasOrdenadas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefasOrdenadas[index];
                      final disciplina = StorageService.instance.disciplinas.firstWhere(
                            (d) => d.id == tarefa.disciplinaId,
                            orElse: () => Disciplina(id: '', nome: 'Sem disciplina'),
                          );
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(tarefa.titulo),
                          subtitle: Text('${tarefa.data} • ${disciplina.nome}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
