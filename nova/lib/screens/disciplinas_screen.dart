import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../widgets/index.dart';
import '../utils/index.dart';

class DisciplinasScreen extends StatefulWidget {
  const DisciplinasScreen({super.key});

  @override
  State<DisciplinasScreen> createState() => _DisciplinasScreenState();
}

class _DisciplinasScreenState extends State<DisciplinasScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = StorageService.instance;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Disciplinas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildList(service.disciplinas)),
          RoundedButton(label: 'Adicionar disciplina', expanded: true, onPressed: _showAddDialog),
        ],
      ),
    );
  }

  Widget _buildList(List<Disciplina> disciplinas) {
    if (disciplinas.isEmpty) {
      return const Center(child: Text('Nenhuma disciplina cadastrada.'));
    }
    return ListView.builder(
      itemCount: disciplinas.length,
      itemBuilder: (context, index) {
        final disciplina = disciplinas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            title: Text(disciplina.nome),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteDisciplina(disciplina.id),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova disciplina'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Nome da disciplina'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(onPressed: _addDisciplina, child: const Text('Salvar')),
          ],
        );
      },
    );
  }

  void _addDisciplina() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final service = StorageService.instance;
    service.disciplinas.add(Disciplina(id: DateTime.now().millisecondsSinceEpoch.toString(), nome: name));
    service.saveDisciplinas();
    setState(() {});
    Navigator.pop(context);
  }

  void _deleteDisciplina(String id) {
    final service = StorageService.instance;
    service.disciplinas.removeWhere((d) => d.id == id);
    service.tarefas.removeWhere((t) => t.disciplinaId == id);
    service.saveDisciplinas();
    service.saveTarefas();
    setState(() {});
  }
}
