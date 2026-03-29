import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import 'add_note_screen.dart';

final noteServiceProvider = Provider((ref) => NoteService());
final notesStreamProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  return ref.watch(noteServiceProvider).getNotesStream();
});

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) return const Center(child: Text('No notes yet!'));
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final n = notes[i];
              Color cardColor = Color(int.parse(n.colorHex.replaceFirst('#', '0xff')));
              return GlassCard(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddNoteScreen(note: n))),
                child: Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1)),
                          if (n.isPinned) const Icon(LucideIcons.pin, size: 16),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: Text(n.content, style: const TextStyle(fontSize: 12), maxLines: 5, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen())),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
