import 'package:flutter/material.dart';
import 'package:atividade_rotas/data/task_dao.dart';
import 'package:atividade_rotas/components/tasks.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Task task;

  const UpdateTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final TaskDao _taskDao = TaskDao();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Novo nome da tarefa'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _atualizarTarefa,
              child: Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _atualizarTarefa() async {
    final String novoNome = _controller.text;

    // Atualiza o nome da tarefa existente
    widget.task.name = novoNome;

    // Atualiza a tarefa no banco de dados usando o TaskDao
    await _taskDao.updateTask(widget.task);

    // Fecha a tela de edição e retorna para a tela anterior
    Navigator.pop(context);
  }
}
