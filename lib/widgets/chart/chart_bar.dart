import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(this.item, this.total, this.allCategory, {super.key});

  final ExpenseBucket item;
  final int total;
  final List<ExpenseBucket> allCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Icon(
                      cateIcon[item.category],
                      size: 20,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kDarkColorS.primary
                          : kColorS.onPrimaryContainer,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      cateZhName[item.category]!,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? kDarkColorS.primary
                            : kColorS.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (item.totalExpenses.toDouble() / total),
                    minHeight: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? kDarkColorS.primary
                        : kColorS.primary,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? kDarkColorS.primaryContainer
                            : kColorS.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (allCategory.last.category != item.category) const Divider(),
      ],
    );
  }
}
