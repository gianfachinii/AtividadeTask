import 'package:flutter/material.dart';
import 'package:atividade_rotas/components/tasks.dart';

class TaskInherited extends InheritedWidget {
  final List<Task> taskList;

  TaskInherited({
    Key? key,
    required this.taskList,
    required Widget child,
  }) : super(key: key, child: child);

  static TaskInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskInherited>();
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList != taskList;
  }
}
