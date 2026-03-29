import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../models/note_model.dart';
import 'notes_screen.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  String _colorHex = '#FFFFFF';
  bool _isPinned = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
    _colorHex = widget.note?.colorHex ?? '#FFFFFF';
    _isPinned = widget.note?.isPinned ?? false;
  }

  void _saveNote() async {
    if (_titleCtrl.text.isEmpty && _contentCtrl.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    final note = Note(
      id: widget.note?.id ?? const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      updatedAt: DateTime.now(),
      colorHex: _colorHex,
      isPinned: _isPinned,
    );

    try {
      await ref.read(noteServiceProvider).saveNote(note);
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
      backgroundColor: Color(int.parse(_colorHex.replaceFirst('#', '0xff'))),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isPinned ? LucideIcons.pin : LucideIcons.pinOff),
            onPressed: () => setState(() => _isPinned = !_isPinned),
            color: _isPinned ? AppTheme.primaryLight : null,
          ),
          if (widget.note != null)
            IconButton(
              icon: const Icon(LucideIcons.trash2),
              onPressed: () async {
                await ref.read(noteServiceProvider).deleteNote(widget.note!.id);
                if (mounted) Navigator.pop(context);
              },
            ),
          IconButton(
            icon: _isLoading ? const CircularProgressIndicator() : const Icon(LucideIcons.check),
            onPressed: _isLoading ? null : _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              style: Theme.of(context).textTheme.displaySmall,
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title', filled: false),
            ),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Write your thoughts...', filled: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
