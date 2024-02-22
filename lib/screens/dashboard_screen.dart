import 'package:flutter/material.dart';
import 'package:atividade_rotas/data/task_dao.dart';
import 'package:atividade_rotas/components/tasks.dart';
import 'package:atividade_rotas/screens/update_screen.dart'; // Importe o arquivo correto

import 'cadastro_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskDao _taskDao = TaskDao();
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _tasksFuture = _taskDao.findAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checklist de atividades"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 64,
                backgroundImage: AssetImage('assets/nico.jpg'),
              ),
              accountName: Text("Nico Rei Delas"),
              accountEmail: Text("Nicoreidelas@gmail.com"),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              onTap: () => _onButtonSairClicked(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Task>>(
          future: _tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar tarefas'));
            } else {
              final tasks = snapshot.data ?? [];
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Icon(Icons.check),
                    title: Text(task.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editTask(context, task); // Correção aqui
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(context, task);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onButtonCadastrarClicked(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _onButtonSairClicked(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/login");
  }

  void _onButtonCadastrarClicked(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen()),
    ).then((_) {
      _loadTasks();
    });
  }

  void _editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateTaskScreen(task: task),
      ),
    ).then((_) {
      _loadTasks();
    });
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar exclusão"),
          content: Text("Tem certeza de que deseja excluir esta tarefa?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _taskDao.deleteTask(task);
                _loadTasks();
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }
}
