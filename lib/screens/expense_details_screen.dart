
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final String expenseId;

  const ExpenseDetailsScreen({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    final expense = provider.expenses.firstWhere(
      (item) => item.id == expenseId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text('Amount: ₹${expense.amount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Text('Category: ${expense.category}'),
            const SizedBox(height: 12),
            Text(
              'Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}',
            ),
            const SizedBox(height: 12),
            Text(
              'Note: ${expense.note.isEmpty ? "No note" : expense.note}',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Delete Expense'),
                      content: const Text(
                        'Are you sure you want to delete this expense?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await context
                        .read<ExpenseProvider>()
                        .deleteExpense(expenseId);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
