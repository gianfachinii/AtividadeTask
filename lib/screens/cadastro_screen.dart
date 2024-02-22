import 'package:flutter/material.dart';
import 'package:atividade_rotas/data/task_dao.dart';
import 'package:atividade_rotas/components/tasks.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(context);
                if (confirmed != null && confirmed) {
                  final taskName = taskNameController.text;
                  if (taskName.isNotEmpty) {
                    final taskDao = TaskDao();
                    final task = Task(name: taskName);
                    await taskDao.insertTask(task);
                    Navigator.pop(context); // Fechar tela de cadastro
                    _updateDashboard(context); // Atualizar tela de dashboard
                  }
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar'),
        content: Text('Deseja realmente adicionar esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Função para atualizar a tela de dashboard
  void _updateDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }
}

void main() {
  runApp(const MaterialApp(
    home: CadastroScreen(),
  ));
}
