import 'package:flutter/material.dart';
import 'models/index.dart';
import 'screens/index.dart';
import 'services/index.dart';
import 'utils/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  runApp(const UniAgendaApp());
}

class UniAgendaApp extends StatelessWidget {
  const UniAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniAgenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          centerTitle: true,
        ),
      ),
      home: const MainScreen(),
      routes: {
        TarefaDetalheScreen.routeName: (context) {
          final tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa;
          return TarefaDetalheScreen(tarefa: tarefa);
        },
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const _titles = [
    'Início',
    'Disciplinas',
    'Tarefas',
    'Calendário',
  ];

  final _screens = const [
    HomeScreen(),
    DisciplinasScreen(),
    TarefasScreen(),
    CalendarioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UniAgenda')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade600,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Disc.'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Tarefas'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendário'),
        ],
      ),
    );
  }
}
