import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final _controller = StreamController<List<Expense>>.broadcast();

  bool get _isInit => Firebase.apps.isNotEmpty;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String get _userId => _isInit ? (_auth.currentUser?.uid ?? 'anonymous_user') : 'local';

  CollectionReference get _expenseColl => _firestore.collection('users').doc(_userId).collection('expenses');

  ExpenseService() {
    _refreshLocalData();
    _startFirebaseSync();
  }

  Future<void> _refreshLocalData() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('expenses', orderBy: 'date DESC');
    final expenses = maps.map((e) => Expense.fromJsonSql(e)).toList();
    _controller.add(expenses);
  }

  void _startFirebaseSync() {
    if (!_isInit) return;
    _expenseColl.snapshots().listen((snapshot) async {
       final db = await DatabaseService.instance.database;
       for (var doc in snapshot.docs) {
          try {
             final e = Expense.fromJson(doc.data() as Map<String, dynamic>, doc.id);
             await db.insert('expenses', e.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (_) {}
       }
       _refreshLocalData();
    });
  }

  Future<void> addExpense(Expense expense) async {
    final db = await DatabaseService.instance.database;
    await db.insert('expenses', expense.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
    _refreshLocalData();
    
    if (_isInit) {
      await _expenseColl.doc(expense.id).set(expense.toJson()).catchError((_) {});
    }
  }

  Stream<List<Expense>> getExpensesStream() {
    _refreshLocalData();
    return _controller.stream;
  }
}
