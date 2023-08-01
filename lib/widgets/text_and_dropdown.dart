import 'package:flutter/material.dart';

import '../main.dart';
import '../models/expense.dart';

class TextAndDropdown<T> extends StatelessWidget {
  const TextAndDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textStyle = TextStyle(
      fontSize: 14,
      color: Theme.of(context).primaryColor,
    );
    final labelStyle = TextStyle(
      fontSize: 14,
      color: isDarkMode
          ? kDarkColorS.onPrimaryContainer
          : const Color.fromARGB(255, 55, 55, 55),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: labelStyle,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode ? kDarkColorS.onPrimary : kColorS.onPrimary,
          ),
          child: DropdownButton<T>(
            underline: const SizedBox(),
            isExpanded: true,
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                    value: e,
                    child: Row(
                      children: [
                        Icon(
                          cateIcon[e]!,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (e as Category).name.toUpperCase(),
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            value: value,
            icon: const Icon(
              Icons.arrow_drop_down_rounded,
              size: 16,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
