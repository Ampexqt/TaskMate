import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class FirestoreTaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'tasks';

  // Get reference to tasks collection
  CollectionReference get _tasksCollection =>
      _firestore.collection(_collectionName);

  /// Get all tasks from Firestore
  Future<List<Task>> getAllTasks() async {
    try {
      final querySnapshot = await _tasksCollection.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Use Firestore document ID
        return TaskModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  /// Get tasks as a stream (real-time updates)
  Stream<List<Task>> getTasksStream() {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskModel.fromJson(data).toEntity();
      }).toList();
    });
  }

  /// Add a new task to Firestore
  Future<void> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final taskJson = taskModel.toJson();

      // Remove the id field as Firestore will generate it
      taskJson.remove('id');

      await _tasksCollection.doc(task.id).set(taskJson);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  /// Update an existing task in Firestore
  Future<void> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final taskJson = taskModel.toJson();

      // Remove the id field
      taskJson.remove('id');

      await _tasksCollection.doc(task.id).update(taskJson);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  /// Delete a task from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// Get a single task by ID
  Future<Task?> getTaskById(String taskId) async {
    try {
      final doc = await _tasksCollection.doc(taskId).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return TaskModel.fromJson(data).toEntity();
    } catch (e) {
      print('Error getting task by ID: $e');
      return null;
    }
  }

  /// Clear all tasks (use with caution!)
  Future<void> clearAllTasks() async {
    try {
      final querySnapshot = await _tasksCollection.get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error clearing all tasks: $e');
      rethrow;
    }
  }

  /// Get tasks filtered by completion status
  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    try {
      final querySnapshot = await _tasksCollection
          .where('isCompleted', isEqualTo: isCompleted)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      print('Error getting tasks by status: $e');
      return [];
    }
  }

  /// Get tasks for today
  Future<List<Task>> getTodayTasks() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final querySnapshot = await _tasksCollection
          .where(
            'dueDate',
            isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
          )
          .where('dueDate', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      print('Error getting today tasks: $e');
      return [];
    }
  }

  /// Get upcoming tasks (future tasks)
  Future<List<Task>> getUpcomingTasks() async {
    try {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      final querySnapshot = await _tasksCollection
          .where('dueDate', isGreaterThanOrEqualTo: tomorrow.toIso8601String())
          .orderBy('dueDate', descending: false)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskModel.fromJson(data).toEntity();
      }).toList();
    } catch (e) {
      print('Error getting upcoming tasks: $e');
      return [];
    }
  }

  /// Batch save tasks (useful for migration from SharedPreferences)
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final batch = _firestore.batch();

      for (var task in tasks) {
        final taskModel = TaskModel.fromEntity(task);
        final taskJson = taskModel.toJson();
        taskJson.remove('id');

        final docRef = _tasksCollection.doc(task.id);
        batch.set(docRef, taskJson);
      }

      await batch.commit();
    } catch (e) {
      print('Error batch saving tasks: $e');
      rethrow;
    }
  }
}
