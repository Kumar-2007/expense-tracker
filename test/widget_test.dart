
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/providers/expense_provider.dart';

void main() {
  testWidgets('Expense Tracker dashboard loads', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ExpenseProvider()..loadExpenses(),
        child: const ExpenseTrackerApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Total Expenses'), findsOneWidget);
  });
}
