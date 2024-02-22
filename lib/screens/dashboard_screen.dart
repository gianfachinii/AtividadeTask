import 'package:flutter/material.dart';
import 'package:atividade_rotas/data/task_dao.dart';

import 'package:atividade_rotas/components/tasks.dart';

import 'cadastro_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskDao _taskDao = TaskDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checklist de atividades"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Nico Rei Delas"),
              accountEmail: Text("Nicoreidelas@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/nico.jpg'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sair"),
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskDao.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text("Erro ao carregar as tasks"));
            }
            return ListView(
              children: snapshot.data!.map((task) => ListTile(
                leading: const Icon(Icons.check),
                title: Text(task.name),
              )).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
