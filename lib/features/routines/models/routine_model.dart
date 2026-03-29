

class Routine {
  final String id;
  final String title;
  final String description;
  final String timeOfDay; // 'morning', 'afternoon', 'night'
  final int streak;
  final bool isDoneToday;

  Routine({
    required this.id,
    required this.title,
    required this.description,
    required this.timeOfDay,
    this.streak = 0,
    this.isDoneToday = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timeOfDay': timeOfDay,
      'streak': streak,
      'isDoneToday': isDoneToday,
    };
  }

  factory Routine.fromJson(Map<String, dynamic> map, String docId) {
    return Routine(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timeOfDay: map['timeOfDay'] ?? 'morning',
      streak: map['streak'] ?? 0,
      isDoneToday: map['isDoneToday'] ?? false,
    );
  }

  Map<String, dynamic> toJsonSql() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timeOfDay': timeOfDay,
      'streak': streak,
      'isDoneToday': isDoneToday ? 1 : 0,
    };
  }

  factory Routine.fromJsonSql(Map<String, dynamic> map) {
    return Routine(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      timeOfDay: map['timeOfDay'] as String,
      streak: map['streak'] as int,
      isDoneToday: (map['isDoneToday'] as int) == 1,
    );
  }
}
