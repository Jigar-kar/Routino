import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

final tasksStreamProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  return taskService.getTasksStream();
});
