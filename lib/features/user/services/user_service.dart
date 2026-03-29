import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/user_model.dart';

class UserService {
  final _controller = StreamController<UserModel?>.broadcast();

  bool get _isInit => Firebase.apps.isNotEmpty;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String get _userId => _isInit ? (_auth.currentUser?.uid ?? 'anonymous_user') : 'local';

  DocumentReference get _userDoc => _firestore.collection('users').doc(_userId);

  UserService() {
    _refreshLocalData();
    _startFirebaseSync();
  }

  Future<void> _refreshLocalData() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('user', limit: 1);
    if (maps.isNotEmpty) {
      final user = UserModel.fromJson(maps.first);
      _controller.add(user);
    } else {
      _controller.add(null);
    }
  }

  void _startFirebaseSync() {
    if (!_isInit) return;
    _userDoc.snapshots().listen((snapshot) async {
      final db = await DatabaseService.instance.database;
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final user = UserModel.fromJson(data..['id'] = _userId);
        await db.insert('user', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      _refreshLocalData();
    });
  }

  Future<void> saveUser(UserModel user) async {
    final db = await DatabaseService.instance.database;
    await db.insert('user', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    _refreshLocalData();

    if (_isInit) {
      await _userDoc.set(user.toJson()).catchError((_) {});
    }
  }

  Future<void> updateUser(UserModel user) async {
    final db = await DatabaseService.instance.database;
    await db.update('user', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
    _refreshLocalData();

    if (_isInit) {
      await _userDoc.update(user.toJson()).catchError((_) {});
    }
  }

  Future<void> deleteUser(String userId) async {
    final db = await DatabaseService.instance.database;
    await db.delete('user', where: 'id = ?', whereArgs: [userId]);
    _controller.add(null);

    if (_isInit) {
      await _userDoc.delete().catchError((_) {});
    }
  }

  Stream<UserModel?> getUserStream() {
    _refreshLocalData();
    return _controller.stream;
  }
}