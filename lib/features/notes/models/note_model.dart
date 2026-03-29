import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;
  final String colorHex;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.colorHex = '#FFFFFF',
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'colorHex': colorHex,
      'isPinned': isPinned,
    };
  }

  factory Note.fromJson(Map<String, dynamic> map, String docId) {
    return Note(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      colorHex: map['colorHex'] ?? '#FFFFFF',
      isPinned: map['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toJsonSql() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'colorHex': colorHex,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  factory Note.fromJsonSql(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      colorHex: map['colorHex'] as String,
      isPinned: (map['isPinned'] as int) == 1,
    );
  }
}
