import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/expense.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart(this.expenses, {super.key});

  final List<Expense> expenses;

  List<ExpenseBucket> get allCategory {
    return [
      ExpenseBucket.fromCategory(expenses, Category.food),
      ExpenseBucket.fromCategory(expenses, Category.learn),
      ExpenseBucket.fromCategory(expenses, Category.medical),
      ExpenseBucket.fromCategory(expenses, Category.shopping),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var item in allCategory) {
      total += item.totalExpenses;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? kDarkColorS.onPrimary
            : kColorS.secondaryContainer,
        border: Border.all(
          width: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? kDarkColorS.primary
              : kColorS.primary,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        children: [
          ...allCategory.map((e) => ChartBar(e, total, allCategory)),
        ],
      ),
    );
  }
}
