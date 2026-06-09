import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';
import '../widgets/index.dart';
import '../utils/index.dart';

class TarefasScreen extends StatefulWidget {
  const TarefasScreen({super.key});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final _tituloController = TextEditingController();
  final _dataController = TextEditingController();
  String? _selectedDisciplinaId;
  String _disciplinaFilter = 'Todas';

  @override
  Widget build(BuildContext context) {
    final service = StorageService.instance;
    final disciplinas = service.disciplinas;
    final tarefas = _filteredTarefas(service);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tarefas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle), onPressed: _showAddDialog),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildFilter(disciplinas),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildList(tarefas)),
        ],
      ),
    );
  }

  List<Tarefa> _filteredTarefas(StorageService service) {
    final all = service.tarefas;
    if (_disciplinaFilter == 'Todas') return all;
    return all.where((t) => t.disciplinaId == _disciplinaFilter).toList();
  }

  Widget _buildFilter(List<Disciplina> disciplinas) {
    final items = ['Todas', ...disciplinas.map((d) => d.id)];
    return DropdownButtonFormField<String>(
      value: _disciplinaFilter,
      decoration: const InputDecoration(labelText: 'Filtrar por disciplina'),
      items: [
        const DropdownMenuItem(value: 'Todas', child: Text('Todas')),
        ...disciplinas.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome))),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _disciplinaFilter = value);
      },
    );
  }

  Widget _buildList(List<Tarefa> tarefas) {
    if (tarefas.isEmpty) {
      return const Center(child: Text('Nenhuma tarefa encontrada.'));
    }
    return ListView.builder(
      itemCount: tarefas.length,
      itemBuilder: (context, index) {
        final tarefa = tarefas[index];
        final disciplina = StorageService.instance.disciplinas.firstWhere(
              (d) => d.id == tarefa.disciplinaId,
              orElse: () => Disciplina(id: '', nome: 'Sem disciplina'),
            );
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: CheckboxListTile(
            value: tarefa.concluida,
            onChanged: (_) => _toggleComplete(tarefa),
            title: Text(tarefa.titulo),
            subtitle: Text('${disciplina.nome} • ${tarefa.data}'),
            secondary: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTarefa(tarefa.id),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog() {
    _tituloController.clear();
    _dataController.clear();
    _selectedDisciplinaId = StorageService.instance.disciplinas.isNotEmpty
        ? StorageService.instance.disciplinas.first.id
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
              const SizedBox(height: AppSpacing.sm),
              TextField(controller: _dataController, decoration: const InputDecoration(labelText: 'Data (dd/mm)')),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: _selectedDisciplinaId,
                decoration: const InputDecoration(labelText: 'Disciplina'),
                items: StorageService.instance.disciplinas
                    .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDisciplinaId = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(onPressed: _addTarefa, child: const Text('Salvar')),
          ],
        );
      },
    );
  }

  void _addTarefa() {
    final titulo = _tituloController.text.trim();
    final data = _dataController.text.trim();
    final disciplinaId = _selectedDisciplinaId;
    if (titulo.isEmpty || data.isEmpty || disciplinaId == null) return;
    final service = StorageService.instance;
    service.tarefas.add(Tarefa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: titulo,
      disciplinaId: disciplinaId,
      data: data,
    ));
    service.saveTarefas();
    setState(() {});
    Navigator.pop(context);
  }

  void _toggleComplete(Tarefa tarefa) {
    final service = StorageService.instance;
    final index = service.tarefas.indexWhere((t) => t.id == tarefa.id);
    if (index == -1) return;
    service.tarefas[index] = Tarefa(
      id: tarefa.id,
      titulo: tarefa.titulo,
      disciplinaId: tarefa.disciplinaId,
      data: tarefa.data,
      concluida: !tarefa.concluida,
    );
    service.saveTarefas();
    setState(() {});
  }

  void _deleteTarefa(String id) {
    final service = StorageService.instance;
    service.tarefas.removeWhere((t) => t.id == id);
    service.saveTarefas();
    setState(() {});
  }
}
