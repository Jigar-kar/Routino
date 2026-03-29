import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/task_provider.dart';

import '../widgets/task_list_tile.dart';
import 'add_task_screen.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: tasksAsyncValue.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.clipboardList, size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No tasks yet!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Tap the + button to add your first task.', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }
          
          final todayTasks = tasks.where((t) => _isToday(t.dateTime)).toList();
          final upcomingTasks = tasks.where((t) => !_isToday(t.dateTime) && !t.dateTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))).toList();
          
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (todayTasks.isNotEmpty) ...[
                Text('Today', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...todayTasks.map((t) => TaskListTile(task: t)).toList(),
                const SizedBox(height: 32),
              ],
              if (upcomingTasks.isNotEmpty) ...[
                Text('Upcoming', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                ...upcomingTasks.map((t) => TaskListTile(task: t)).toList(),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
