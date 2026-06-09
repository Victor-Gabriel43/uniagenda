import 'package:flutter/material.dart';
import '../services/index.dart';
import '../utils/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final service = StorageService.instance;
    final disciplinaCount = service.disciplinas.length;
    final pendingTasks = service.tarefas.where((t) => !t.concluida).length;
    final doneTasks = service.tarefas.where((t) => t.concluida).length;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumo', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          _buildCard('Disciplinas cadastradas', disciplinaCount.toString()),
          _buildCard('Tarefas pendentes', pendingTasks.toString()),
          _buildCard('Tarefas concluídas', doneTasks.toString()),
          const SizedBox(height: AppSpacing.lg),
          const Text('Próximas atividades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildUpcomingTasks()),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildUpcomingTasks() {
    final tarefas = StorageService.instance.tarefas.where((t) => !t.concluida).toList();
    if (tarefas.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa registrada.'));
    }
    tarefas.sort((a, b) => a.data.compareTo(b.data));
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        return ListTile(
          title: Text(tarefa.titulo),
          subtitle: Text(tarefa.data),
        );
      },
    );
  }
}
