import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/expense.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(this.item, this.total, this.maxTotal, {Key? key})
      : super(key: key);

  final ExpenseBucket item;
  final int total;
  final int maxTotal;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final percentage = (item.totalExpenses.toDouble() / total * 100).floor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          cateIcon[item.category],
          size: 20,
          color: isDarkMode ? kDarkColorS.primary : kColorS.onPrimaryContainer,
        ),
        const SizedBox(height: 4),
        Text(
          item.category.name.toUpperCase(),
          style: TextStyle(
            color:
                isDarkMode ? kDarkColorS.primary : kColorS.onPrimaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentage%',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: FractionallySizedBox(
            heightFactor: item.totalExpenses.toDouble() / maxTotal,
            child: Container(
              width: 24,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                  bottom: Radius.circular(0),
                ),
                color: isDarkMode
                    ? kDarkColorS.onPrimaryContainer
                    : kColorS.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
