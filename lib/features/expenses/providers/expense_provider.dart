import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/expense_service.dart';
import '../models/expense_model.dart';

final expenseServiceProvider = Provider((ref) => ExpenseService());

final expensesStreamProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  return ref.watch(expenseServiceProvider).getExpensesStream();
});
