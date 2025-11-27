import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/firestore_task_repository.dart';
import '../../domain/entities/task.dart';
import '../../domain/enums/priority.dart';

/// Test screen to verify Firebase Firestore connection
class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  final FirestoreTaskRepository _repository = FirestoreTaskRepository();
  String _status = 'Ready to test';
  bool _isLoading = false;

  Future<void> _testFirestoreConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing Firestore connection...';
    });

    try {
      // Test 1: Check Firestore instance
      final firestore = FirebaseFirestore.instance;
      setState(() => _status = '✅ Firestore instance created');
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 2: Try to read from Firestore
      setState(() => _status = 'Reading tasks from Firestore...');
      final tasks = await _repository.getAllTasks();
      setState(() => _status = '✅ Read ${tasks.length} tasks from Firestore');
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 3: Try to write to Firestore
      setState(() => _status = 'Creating test task...');
      final testTask = Task(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Firebase Test Task',
        description:
            'This is a test task created to verify Firestore connection',
        priority: Priority.medium,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await _repository.addTask(testTask);
      setState(() => _status = '✅ Test task created successfully');
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 4: Verify the task was created
      setState(() => _status = 'Verifying task creation...');
      final verifyTask = await _repository.getTaskById(testTask.id);
      if (verifyTask != null) {
        setState(() => _status = '✅ Task verified: ${verifyTask.title}');
      } else {
        setState(() => _status = '❌ Task verification failed');
      }
      await Future.delayed(const Duration(milliseconds: 500));

      // Test 5: Delete the test task
      setState(() => _status = 'Cleaning up test task...');
      await _repository.deleteTask(testTask.id);
      setState(() => _status = '✅ Test task deleted');
      await Future.delayed(const Duration(milliseconds: 500));

      // Final status
      setState(() {
        _status =
            '🎉 All tests passed! Firebase Firestore is working correctly.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Connection Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_done, size: 100, color: Colors.blue),
              const SizedBox(height: 32),
              const Text(
                'Firebase Firestore Test',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _testFirestoreConnection,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Text('Run Test'),
                  ),
                ),
              const SizedBox(height: 16),
              const Text(
                'Note: Make sure Firestore Database is enabled in Firebase Console',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
