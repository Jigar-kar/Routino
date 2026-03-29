import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/primary_button.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../../../core/providers/currency_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _titleCtrl = TextEditingController();
  final _amtCtrl = TextEditingController();
  String _category = 'Food';
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  void _saveExpense() async {
    if (_titleCtrl.text.isEmpty || _amtCtrl.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    final exp = Expense(
      id: const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      amount: double.tryParse(_amtCtrl.text.trim()) ?? 0.0,
      category: _category,
      date: _date,
    );

    try {
      await ref.read(expenseServiceProvider).addExpense(exp);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Store / Title', prefixIcon: Icon(LucideIcons.shoppingBag))),
            const SizedBox(height: 16),
            TextField(keyboardType: const TextInputType.numberWithOptions(decimal: true), controller: _amtCtrl, decoration: InputDecoration(labelText: 'Amount $currency', prefixIcon: const Icon(LucideIcons.banknote))),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(LucideIcons.tag)),
              items: ['Food', 'Transport', 'Entertainment', 'Bills', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final dt = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
                if (dt != null) setState(() => _date = dt);
              },
              icon: const Icon(LucideIcons.calendar),
              label: Text(DateFormat('MMM dd, yyyy').format(_date)),
            ),
            const SizedBox(height: 32),
            PrimaryButton(text: 'Save Expense', isLoading: _isLoading, onPressed: _saveExpense),
          ],
        ),
      ),
    );
  }
}
