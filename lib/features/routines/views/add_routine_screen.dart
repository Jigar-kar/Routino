import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/primary_button.dart';
import '../models/routine_model.dart';
import '../providers/routine_provider.dart';

class AddRoutineScreen extends ConsumerStatefulWidget {
  const AddRoutineScreen({super.key});

  @override
  ConsumerState<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends ConsumerState<AddRoutineScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _timeOfDay = 'morning';
  bool _isLoading = false;

  void _saveRoutine() async {
    if (_titleCtrl.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    final routine = Routine(
      id: const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      timeOfDay: _timeOfDay,
    );

    try {
      await ref.read(routineServiceProvider).saveRoutine(routine);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Habit Title', prefixIcon: Icon(LucideIcons.activity))),
            const SizedBox(height: 16),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Why do you want to build this? (Optional)', prefixIcon: Icon(LucideIcons.alignLeft))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _timeOfDay,
              decoration: const InputDecoration(labelText: 'Time of Day', prefixIcon: Icon(LucideIcons.sun)),
              items: ['morning', 'afternoon', 'night'].map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
              onChanged: (v) => setState(() => _timeOfDay = v ?? _timeOfDay),
            ),
            const SizedBox(height: 40),
            PrimaryButton(text: 'Save Habit', isLoading: _isLoading, onPressed: _saveRoutine),
          ],
        ),
      ),
    );
  }
}
