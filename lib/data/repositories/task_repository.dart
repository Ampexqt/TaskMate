import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> getAllTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      
      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList
          .map((taskJson) => TaskModel.fromJson(taskJson as Map<String, dynamic>).toEntity())
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskModels = tasks.map((task) => TaskModel.fromEntity(task)).toList();
      final tasksJson = json.encode(taskModels.map((task) => task.toJson()).toList());
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTask(Task task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  Future<Task?> getTaskById(String taskId) async {
    final tasks = await getAllTasks();
    try {
      return tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
