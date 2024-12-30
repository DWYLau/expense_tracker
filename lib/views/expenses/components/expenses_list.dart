import 'package:flutter/material.dart';

import '../../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.removeExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        ///key to distinguish unique widgets
        key: ValueKey(expenses[index]),

        ///onDismissed has to take a direction parameter
        onDismissed: (direction) {
          removeExpense(expenses[index]);
        },

        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
