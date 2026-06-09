import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

class StorageService {
  static final StorageService instance = StorageService._();

  StorageService._();

  SharedPreferences? _prefs;
  final List<Disciplina> disciplinas = [];
  final List<Tarefa> tarefas = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDisciplinas();
    _loadTarefas();
  }

  void _loadDisciplinas() {
    final raw = _prefs?.getString('disciplinas');
    if (raw == null) return;
    final list = jsonDecode(raw) as List<dynamic>;
    disciplinas
      ..clear()
      ..addAll(list.map((item) => Disciplina.fromJson(item as Map<String, dynamic>)));
  }

  void _loadTarefas() {
    final raw = _prefs?.getString('tarefas');
    if (raw == null) return;
    final list = jsonDecode(raw) as List<dynamic>;
    tarefas
      ..clear()
      ..addAll(list.map((item) => Tarefa.fromJson(item as Map<String, dynamic>)));
  }

  Future<void> saveDisciplinas() async {
    await _prefs?.setString(
      'disciplinas',
      jsonEncode(disciplinas.map((d) => d.toJson()).toList()),
    );
  }

  Future<void> saveTarefas() async {
    await _prefs?.setString(
      'tarefas',
      jsonEncode(tarefas.map((t) => t.toJson()).toList()),
    );
  }
}
