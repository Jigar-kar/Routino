import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/routine_model.dart';

class RoutineService {
  final _controller = StreamController<List<Routine>>.broadcast();

  bool get _isInit => Firebase.apps.isNotEmpty;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String get _userId => _isInit ? (_auth.currentUser?.uid ?? 'anonymous_user') : 'local';

  CollectionReference get _routineColl => _firestore.collection('users').doc(_userId).collection('routines');

  RoutineService() {
    _refreshLocalData();
    _startFirebaseSync();
  }

  Future<void> _refreshLocalData() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('routines');
    final routines = maps.map((e) => Routine.fromJsonSql(e)).toList();
    _controller.add(routines);
  }

  void _startFirebaseSync() {
    if (!_isInit) return;
    _routineColl.snapshots().listen((snapshot) async {
       final db = await DatabaseService.instance.database;
       for (var doc in snapshot.docs) {
          try {
             final r = Routine.fromJson(doc.data() as Map<String, dynamic>, doc.id);
             await db.insert('routines', r.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (_) {}
       }
       _refreshLocalData();
    });
  }

  Future<void> saveRoutine(Routine routine) async {
    final db = await DatabaseService.instance.database;
    await db.insert('routines', routine.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
    _refreshLocalData();
    
    if (_isInit) {
      await _routineColl.doc(routine.id).set(routine.toJson()).catchError((_) {});
    }
  }

  Future<void> deleteRoutine(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete('routines', where: 'id = ?', whereArgs: [id]);
    _refreshLocalData();
    
    if (_isInit) {
      await _routineColl.doc(id).delete().catchError((_) {});
    }
  }

  Future<void> markRoutineDone(String routineId, bool done, int currentStreak) async {
    final db = await DatabaseService.instance.database;
    int streak = done ? currentStreak + 1 : (currentStreak > 0 ? currentStreak - 1 : 0);
    
    await db.update('routines', {
      'isDoneToday': done ? 1 : 0,
      'streak': streak,
    }, where: 'id = ?', whereArgs: [routineId]);
    _refreshLocalData();
    
    if (_isInit) {
      await _routineColl.doc(routineId).update({
        'isDoneToday': done,
        'streak': streak,
      }).catchError((_) {});
    }
  }

  Stream<List<Routine>> getRoutinesStream() {
    _refreshLocalData();
    return _controller.stream;
  }
}
