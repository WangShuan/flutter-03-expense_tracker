import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.expenseData, this.removeExpenses, {super.key});

  final List<Expense> expenseData;
  final void Function(Expense) removeExpenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) => Dismissible(
        key: ValueKey(expenseData[i].id),
        background: Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Theme.of(context).brightness == Brightness.dark
              ? kDarkColorS.onError
              : kColorS.error,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.delete,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? kDarkColorS.error
                      : kColorS.onError,
                ),
              ],
            ),
          ),
        ),
        onDismissed: (direction) => removeExpenses(expenseData[i]),
        child: ExpenseItem(
          expenseData[i],
        ),
      ),
      itemCount: expenseData.length,
    );
  }
}
