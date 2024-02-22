import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:atividade_rotas/components/tasks.dart';

class TaskDao {
  // Método para obter o banco de dados
  Future<Database> _getDatabase() async {
    final String path = join(await getDatabasesPath(), 'task_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  // Método para inserir uma nova tarefa
  Future<void> insertTask(Task task) async {
    final Database db = await _getDatabase();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para obter todas as tarefas
  Future<List<Task>> findAll() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  // Método para atualizar uma tarefa existente
  Future<void> updateTask(Task task) async {
    final Database db = await _getDatabase();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Método para excluir uma tarefa com confirmação
  Future<void> deleteTask(Task task) async {
    final Database db = await _getDatabase();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
