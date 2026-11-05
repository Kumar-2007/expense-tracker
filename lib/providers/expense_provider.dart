
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Expense> _expenses = [];

  bool isLoading = false;
  String? errorMessage;

  List<Expense> get expenses => _expenses;

  double get totalExpenses {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  Future<void> loadExpenses() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _expenses = await _storage.loadExpenses();
    } catch (e) {
      errorMessage = 'Unable to load expenses';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _save();
  }

  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere(
      (e) => e.id == updatedExpense.id,
    );

    if (index != -1) {
      _expenses[index] = updatedExpense;
      await _save();
    }
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _save();
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};

    for (var expense in _expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }

    return totals;
  }

  Future<void> _save() async {
    try {
      await _storage.saveExpenses(_expenses);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Unable to save expenses';
    }

    notifyListeners();
  }
}
