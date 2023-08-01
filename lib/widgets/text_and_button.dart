import 'package:flutter/material.dart';

import '../main.dart';

class TextAndButton extends StatelessWidget {
  const TextAndButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    required this.icon,
  });

  final String label;
  final String value;
  final void Function() onPressed;
  final IconData icon;

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
        TextButton.icon(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor:
                isDarkMode ? kDarkColorS.onPrimary : kColorS.onPrimary,
            alignment: Alignment.centerLeft,
          ),
          label: Text(
            value,
            style: textStyle,
            textAlign: TextAlign.left,
          ),
          icon: Icon(
            icon,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
