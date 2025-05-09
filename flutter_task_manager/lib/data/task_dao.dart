import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import 'db_helper.dart';
// tạo cv mới trong csdl
class TaskDao {
  Future<void> insertTask(TaskModel task) async {
    final db = await DBHelper().database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
//hienthitoanbocvtrongud
  Future<List<TaskModel>> getAllTasks() async {
    final db = await DBHelper().database;
    final result = await db.query('tasks');
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }
//hienthicvma1nguoidungdatao
  Future<List<TaskModel>> getTasksByUser(String userId) async {
    final db = await DBHelper().database;
    final result =
    await db.query('tasks', where: 'createdBy = ?', whereArgs: [userId]);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }
//capnhat
  Future<void> updateTask(TaskModel task) async {
    final db = await DBHelper().database;
    await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
//xoa
  Future<void> deleteTask(String id) async {
    final db = await DBHelper().database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

Future<List<TaskModel>> searchTasks(String keyword) async {
  final db = await DBHelper().database;
  final result = await db.query(
    'tasks',
    where: 'title LIKE ? OR description LIKE ?',
    whereArgs: ['%$keyword%', '%$keyword%'],
  );
  return result.map((e) => TaskModel.fromMap(e)).toList();
}

