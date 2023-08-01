import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/expense.dart';
import './expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.expenseData, this.removeExpenses, {super.key});

  final List<Expense> expenseData;
  final void Function(Expense) removeExpenses;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListView.builder(
      itemBuilder: (context, i) => Dismissible(
        key: ValueKey(expenseData[i].id),
        background: Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: isDarkMode ? kDarkColorS.onError : kColorS.error,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.delete,
                  color: isDarkMode ? kDarkColorS.error : kColorS.onError,
                ),
              ],
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) => removeExpenses(expenseData[i]),
        child: ExpenseItem(
          expenseData[i],
        ),
      ),
      itemCount: expenseData.length,
    );
  }
}
