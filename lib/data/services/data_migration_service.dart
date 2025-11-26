import '../repositories/task_repository.dart';
import '../repositories/firestore_task_repository.dart';

/// Utility class to migrate data from SharedPreferences to Firestore
class DataMigrationService {
  final TaskRepository _localRepository = TaskRepository();
  final FirestoreTaskRepository _firestoreRepository =
      FirestoreTaskRepository();

  /// Migrate all tasks from SharedPreferences to Firestore
  Future<MigrationResult> migrateToFirestore() async {
    try {
      // Get all tasks from local storage
      final localTasks = await _localRepository.getAllTasks();

      if (localTasks.isEmpty) {
        return MigrationResult(
          success: true,
          migratedCount: 0,
          message: 'No tasks to migrate',
        );
      }

      // Save all tasks to Firestore
      await _firestoreRepository.saveTasks(localTasks);

      return MigrationResult(
        success: true,
        migratedCount: localTasks.length,
        message:
            'Successfully migrated ${localTasks.length} tasks to Firestore',
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        migratedCount: 0,
        message: 'Migration failed: $e',
      );
    }
  }

  /// Backup Firestore data to local storage
  Future<MigrationResult> backupToLocal() async {
    try {
      // Get all tasks from Firestore
      final firestoreTasks = await _firestoreRepository.getAllTasks();

      if (firestoreTasks.isEmpty) {
        return MigrationResult(
          success: true,
          migratedCount: 0,
          message: 'No tasks to backup',
        );
      }

      // Save all tasks to local storage
      await _localRepository.saveTasks(firestoreTasks);

      return MigrationResult(
        success: true,
        migratedCount: firestoreTasks.length,
        message:
            'Successfully backed up ${firestoreTasks.length} tasks to local storage',
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        migratedCount: 0,
        message: 'Backup failed: $e',
      );
    }
  }

  /// Check if local data exists
  Future<bool> hasLocalData() async {
    final tasks = await _localRepository.getAllTasks();
    return tasks.isNotEmpty;
  }

  /// Check if Firestore data exists
  Future<bool> hasFirestoreData() async {
    final tasks = await _firestoreRepository.getAllTasks();
    return tasks.isNotEmpty;
  }

  /// Clear local data after successful migration
  Future<void> clearLocalData() async {
    await _localRepository.clearAllTasks();
  }
}

/// Result of a migration operation
class MigrationResult {
  final bool success;
  final int migratedCount;
  final String message;

  MigrationResult({
    required this.success,
    required this.migratedCount,
    required this.message,
  });

  @override
  String toString() {
    return 'MigrationResult(success: $success, migratedCount: $migratedCount, message: $message)';
  }
}
