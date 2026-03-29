import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/note_model.dart';

class NoteService {
  final _controller = StreamController<List<Note>>.broadcast();

  bool get _isInit => Firebase.apps.isNotEmpty;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  String get _userId => _isInit ? (_auth.currentUser?.uid ?? 'anonymous_user') : 'local';

  CollectionReference get _noteColl => _firestore.collection('users').doc(_userId).collection('notes');

  NoteService() {
    _refreshLocalData();
    _startFirebaseSync();
  }

  Future<void> _refreshLocalData() async {
    final db = await DatabaseService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'updatedAt DESC');
    final notes = maps.map((e) => Note.fromJsonSql(e)).toList();
    _controller.add(notes);
  }

  void _startFirebaseSync() {
    if (!_isInit) return;
    _noteColl.snapshots().listen((snapshot) async {
       final db = await DatabaseService.instance.database;
       for (var doc in snapshot.docs) {
          try {
             final n = Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
             await db.insert('notes', n.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (_) {}
       }
       _refreshLocalData();
    });
  }

  Future<void> saveNote(Note note) async {
    final db = await DatabaseService.instance.database;
    await db.insert('notes', note.toJsonSql(), conflictAlgorithm: ConflictAlgorithm.replace);
    _refreshLocalData();
    
    if (_isInit) {
      await _noteColl.doc(note.id).set(note.toJson()).catchError((_) {});
    }
  }

  Future<void> deleteNote(String noteId) async {
    final db = await DatabaseService.instance.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
    _refreshLocalData();
    
    if (_isInit) {
      await _noteColl.doc(noteId).delete().catchError((_) {});
    }
  }

  Stream<List<Note>> getNotesStream() {
    _refreshLocalData();
    return _controller.stream;
  }
}
