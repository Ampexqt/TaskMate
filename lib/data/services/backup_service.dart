import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

class BackupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Hash password for security (simple hashing, not production-grade)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Create a new backup account or login
  Future<BackupResult> createOrLoginAccount({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        return BackupResult(
          success: false,
          message: 'Email and password is incorrect',
        );
      }

      // Validate password
      if (password.length < 6) {
        return BackupResult(
          success: false,
          message: 'Email and password is incorrect',
        );
      }

      final hashedPassword = _hashPassword(password);
      final userDoc = _firestore.collection('backup_users').doc(email);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        // User exists, verify password
        final storedHash = docSnapshot.data()?['passwordHash'] as String?;
        if (storedHash == hashedPassword) {
          return BackupResult(
            success: true,
            message: 'Login successful',
            userId: email,
          );
        } else {
          // Generic error - don't reveal if email exists
          return BackupResult(
            success: false,
            message: 'Email and password is incorrect',
          );
        }
      } else {
        // Create new user
        await userDoc.set({
          'email': email,
          'passwordHash': hashedPassword,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return BackupResult(
          success: true,
          message: 'Account created successfully',
          userId: email,
        );
      }
    } catch (e) {
      return BackupResult(
        success: false,
        message: 'Email and password is incorrect',
      );
    }
  }

  /// Backup tasks to Firestore
  Future<BackupResult> backupTasks({
    required String email,
    required List<Task> tasks,
  }) async {
    try {
      final backupCollection = _firestore
          .collection('backup_users')
          .doc(email)
          .collection('tasks');

      // Clear existing tasks
      final existingTasks = await backupCollection.get();
      for (var doc in existingTasks.docs) {
        await doc.reference.delete();
      }

      // Backup new tasks
      final batch = _firestore.batch();
      for (var task in tasks) {
        final taskModel = TaskModel.fromEntity(task);
        final taskJson = taskModel.toJson();
        final docRef = backupCollection.doc(task.id);
        batch.set(docRef, taskJson);
      }
      await batch.commit();

      // Update last backup time
      await _firestore.collection('backup_users').doc(email).update({
        'lastBackup': FieldValue.serverTimestamp(),
        'taskCount': tasks.length,
      });

      return BackupResult(
        success: true,
        message: 'Backed up ${tasks.length} tasks successfully',
        taskCount: tasks.length,
      );
    } catch (e) {
      return BackupResult(success: false, message: 'Backup failed: $e');
    }
  }

  /// Restore tasks from Firestore
  Future<RestoreResult> restoreTasks({required String email}) async {
    try {
      final backupCollection = _firestore
          .collection('backup_users')
          .doc(email)
          .collection('tasks');

      final snapshot = await backupCollection.get();

      if (snapshot.docs.isEmpty) {
        return RestoreResult(
          success: false,
          message: 'No backup found for this account',
          tasks: [],
        );
      }

      final tasks = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TaskModel.fromJson(data).toEntity();
      }).toList();

      return RestoreResult(
        success: true,
        message: 'Restored ${tasks.length} tasks successfully',
        tasks: tasks,
      );
    } catch (e) {
      return RestoreResult(
        success: false,
        message: 'Restore failed: $e',
        tasks: [],
      );
    }
  }

  /// Get backup info
  Future<BackupInfo?> getBackupInfo(String email) async {
    try {
      final userDoc = await _firestore
          .collection('backup_users')
          .doc(email)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      final data = userDoc.data()!;
      final lastBackup = data['lastBackup'] as Timestamp?;
      final taskCount = data['taskCount'] as int? ?? 0;

      return BackupInfo(
        email: email,
        lastBackup: lastBackup?.toDate(),
        taskCount: taskCount,
      );
    } catch (e) {
      return null;
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}

class BackupResult {
  final bool success;
  final String message;
  final String? userId;
  final int? taskCount;

  BackupResult({
    required this.success,
    required this.message,
    this.userId,
    this.taskCount,
  });
}

class RestoreResult {
  final bool success;
  final String message;
  final List<Task> tasks;

  RestoreResult({
    required this.success,
    required this.message,
    required this.tasks,
  });
}

class BackupInfo {
  final String email;
  final DateTime? lastBackup;
  final int taskCount;

  BackupInfo({required this.email, this.lastBackup, required this.taskCount});
}
