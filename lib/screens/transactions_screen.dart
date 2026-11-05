
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import 'expense_details_screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Text('No expenses added yet'),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        expense.category == 'Food'
                            ? Icons.restaurant
                            : expense.category == 'Travel'
                                ? Icons.directions_bus
                                : Icons.receipt,
                      ),
                    ),
                    title: Text(expense.title),
                    subtitle: Text(
                      '${expense.category} • '
                      '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    ),
                    trailing: Text(
                      '₹${expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseDetailsScreen(
                            expenseId: expense.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
