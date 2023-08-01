import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/expense.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart(this.expenses, {super.key});

  final List<Expense> expenses;

  List<ExpenseBucket> get allCategory {
    List<ExpenseBucket> arr = [];
    for (var c in Category.values) {
      arr.add(ExpenseBucket.fromCategory(expenses, c));
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    int maxTotal = 0;
    int total = 0;
    for (final cate in allCategory) {
      if (cate.totalExpenses > maxTotal) maxTotal = cate.totalExpenses;
      total += cate.totalExpenses;
    }

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDarkMode ? kDarkColorS.onPrimary : kColorS.secondaryContainer,
        border: Border.all(
          width: 2,
          color: isDarkMode ? kDarkColorS.primary : kColorS.primary,
        ),
      ),
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          for (var e in allCategory)
            Expanded(
              child: ChartBar(e, total, maxTotal),
            ),
        ],
      ),
    );
  }
}
