import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String priority; // 'low', 'medium', 'high'
  final bool isCompleted;
  final bool reminder;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.priority = 'medium',
    this.isCompleted = false,
    this.reminder = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'priority': priority,
      'isCompleted': isCompleted,
      'reminder': reminder,
    };
  }

  factory Task.fromJson(Map<String, dynamic> map, String docId) {
    return Task(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      priority: map['priority'] ?? 'medium',
      isCompleted: map['isCompleted'] ?? false,
      reminder: map['reminder'] ?? false,
    );
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? dateTime,
    String? priority,
    bool? isCompleted,
    bool? reminder,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      reminder: reminder ?? this.reminder,
    );
  }

  Map<String, dynamic> toJsonSql() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'reminder': reminder ? 1 : 0,
    };
  }

  factory Task.fromJsonSql(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      priority: map['priority'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
      reminder: (map['reminder'] as int) == 1,
    );
  }
}
