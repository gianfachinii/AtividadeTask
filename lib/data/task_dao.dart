import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:atividade_rotas/components/tasks.dart';

class TaskDao {
  Future<Database> _getDatabase() async {
    // Define o caminho do banco de dados.
    final String path = join(await getDatabasesPath(), 'task_database.db');

    // Abre o banco de dados, criando-o se ele não existir.
    return await openDatabase(
      path,
      onCreate: (db, version) {
        // Executa a criação da tabela quando o banco de dados é criado pela primeira vez.
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    final Database db = await _getDatabase();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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
}
