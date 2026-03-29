import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import '../../../core/providers/currency_provider.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsyncValue = ref.watch(expensesStreamProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: expensesAsyncValue.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses recorded.'));
          }

          final total = expenses.fold(0.0, (sum, item) => sum + item.amount);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Total Spent', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text('$currency${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryLight)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Recent Transactions', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              ...expenses.map((expense) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.1),
                        child: Text(currency, style: const TextStyle(color: AppTheme.primaryLight, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${expense.category} • ${DateFormat('MMM dd').format(expense.date)}'),
                      trailing: Text(
                        '-$currency${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
