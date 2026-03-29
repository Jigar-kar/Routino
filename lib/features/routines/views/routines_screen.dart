import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/routine_model.dart';
import '../providers/routine_provider.dart';
import 'add_routine_screen.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Routines')),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) return const Center(child: Text('Add habits to form your routine!'));
          
          final morning = routines.where((r) => r.timeOfDay == 'morning').toList();
          final afternoon = routines.where((r) => r.timeOfDay == 'afternoon').toList();
          final night = routines.where((r) => r.timeOfDay == 'night').toList();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (morning.isNotEmpty) _buildSection(context, 'Morning', morning, ref),
              if (afternoon.isNotEmpty) _buildSection(context, 'Afternoon', afternoon, ref),
              if (night.isNotEmpty) _buildSection(context, 'Night', night, ref),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRoutineScreen())),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Routine> routines, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        ...routines.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(r.title, style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: r.isDoneToday ? TextDecoration.lineThrough : null,
              )),
              subtitle: Text('🔥 ${r.streak} streak'),
              value: r.isDoneToday,
              activeColor: AppTheme.success,
              onChanged: (val) {
                if (val != null) {
                  ref.read(routineServiceProvider).markRoutineDone(r.id, val, r.streak);
                }
              },
            ),
          ),
        )),
        const SizedBox(height: 24),
      ],
    );
  }
}
