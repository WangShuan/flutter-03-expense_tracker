import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenseData, {super.key});

  final Expense expenseData;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? kDarkColorS.primary
                  : kColorS.primary,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? kDarkColorS.onPrimary
                  : kColorS.onPrimary,
              child: Icon(
                cateIcon[expenseData.category],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expenseData.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                      ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '消費日期：${expenseData.formatterTime}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            Text(
              'NT\$${expenseData.price.toString()}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
