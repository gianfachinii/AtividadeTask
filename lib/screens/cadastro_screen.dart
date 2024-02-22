import 'package:flutter/material.dart';

import 'package:atividade_rotas/data/task_dao.dart';
import 'package:atividade_rotas/components/tasks.dart';


void main() {
  runApp(const CadastroScreen());
}

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 84.0),
          child: Column(
            children: [

              ElevatedButton(
                onPressed: () => onButtonCadastrarClicked(context),
                child: Text('Cadastrar'),
              )
            ],
          ),

        ),
      ),
    );
  }
}

void onButtonCadastrarClicked(BuildContext context) async {
  final taskNameController = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Nova Tarefa'),
      content: TextField(
        controller: taskNameController,
        decoration: InputDecoration(labelText: 'Nome da Tarefa'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final taskName = taskNameController.text;
            if (taskName.isNotEmpty) {
              final taskDao = TaskDao();
              final task = Task(name: taskName);
              await taskDao.insertTask(task);
              Navigator.pop(context);
            }
          },
          child: Text('Salvar'),
        ),
      ],
    ),
  );
}
