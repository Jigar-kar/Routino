import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/task_model.dart';

class TaskService {
  final _controller = StreamController<List<Task>>.broadcast();

  bool get _isInit => Firebase.apps.isNotEmpty;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String get _userId => _isInit ? (_auth.currentUser?.uid ?? 'anonymous_user') : 'local';

  CollectionReference get _taskCollection => _firestore.collection('users').doc(_userId).collection('tasks');

  TaskService() {
    _refreshLocalData();
    _startFirebaseSync();
  }

  Future<void> _refreshLocalData() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'dateTime ASC');
    final tasks = maps.map((e) => Task.fromJsonSql(e)).toList();
    _controller.add(tasks);
  }

  void _startFirebaseSync() {
    if (!_isInit) return;
    _taskCollection.snapshots().listen((snapshot) async {
       final db = await DatabaseService.instance.database;
       for (var doc in snapshot.docs) {
          try {
             final t = Task.fromJson(doc.data() as Map<String, dynamic>, doc.id);
             await db.insert('tasks', t.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
             // Ignore corrupted doc
          }
       }
       _refreshLocalData();
    });
  }

  Future<void> addTask(Task task) async {
    final db = await DatabaseService.instance.database;
    await db.insert('tasks', task.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
    _refreshLocalData();

    // Schedule or cancel reminder
    if (task.reminder) {
      await NotificationService().scheduleTaskReminder(
        id: task.id.hashCode,
        title: '⏰ Task Reminder',
        body: task.title,
        scheduledTime: task.dateTime,
      );
    }

    if (_isInit) {
      await _taskCollection.doc(task.id).set(task.toJson()).catchError((_) {});
    }
  }

  Future<void> updateTask(Task task) async {
    final db = await DatabaseService.instance.database;
    await db.update('tasks', task.toJsonSql(), where: 'id = ?', whereArgs: [task.id]);
    _refreshLocalData();

    // Re-schedule or cancel reminder based on updated state
    if (task.reminder) {
      await NotificationService().scheduleTaskReminder(
        id: task.id.hashCode,
        title: '⏰ Task Reminder',
        body: task.title,
        scheduledTime: task.dateTime,
      );
    } else {
      await NotificationService().cancelReminder(task.id.hashCode);
    }

    if (_isInit) {
      await _taskCollection.doc(task.id).update(task.toJson()).catchError((_) {});
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    final db = await DatabaseService.instance.database;
    await db.update('tasks', {'isCompleted': isCompleted ? 1 : 0}, where: 'id = ?', whereArgs: [taskId]);
    _refreshLocalData();
    
    if (_isInit) {
      await _taskCollection.doc(taskId).update({'isCompleted': isCompleted}).catchError((_) {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    final db = await DatabaseService.instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
    _refreshLocalData();

    // Cancel any pending reminder for this task
    await NotificationService().cancelReminder(taskId.hashCode);

    if (_isInit) {
      await _taskCollection.doc(taskId).delete().catchError((_) {});
    }
  }

  Stream<List<Task>> getTasksStream() {
    _refreshLocalData();
    return _controller.stream;
  }
}
