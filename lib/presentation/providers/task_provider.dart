import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/priority.dart';
import '../../data/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  List<Task> get todayTasks => _tasks
      .where((task) => !task.isCompleted && task.isToday)
      .toList();

  List<Task> get upcomingTasks => _tasks
      .where((task) => !task.isCompleted && task.isUpcoming)
      .toList();

  List<Task> get completedTasks => _tasks
      .where((task) => task.isCompleted)
      .toList();

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _repository.getAllTasks();
    } catch (e) {
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required Priority priority,
    required DateTime dueDate,
  }) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await _repository.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _tasks.firstWhere((t) => t.id == taskId);
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);
    await loadTasks();
  }

  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllTasks() async {
    await _repository.clearAllTasks();
    await loadTasks();
  }
}
