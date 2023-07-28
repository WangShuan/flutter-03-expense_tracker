import 'package:flutter/material.dart';

import './widgets/expenses.dart';

var kColorS = ColorScheme.fromSeed(
  seedColor: Colors.lightGreenAccent.shade100,
);

var kDarkColorS = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 42, 96, 8),
  brightness: Brightness.dark,
);

void main() {
  runApp(
    MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorS,
        primaryColor: kDarkColorS.primary,
        scaffoldBackgroundColor: kDarkColorS.background,
        appBarTheme: const AppBarTheme().copyWith(
          foregroundColor: kDarkColorS.primary,
          backgroundColor: kDarkColorS.onPrimary,
        ),
        cardTheme: const CardTheme().copyWith(
          elevation: 0,
          color: kDarkColorS.onPrimary.withOpacity(.5),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              elevation: 0,
              backgroundColor: kDarkColorS.onPrimary,
              foregroundColor: kDarkColorS.primary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: kDarkColorS.onBackground,
            foregroundColor: kDarkColorS.onPrimary,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontSize: 20,
                color: kDarkColorS.primary,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                color: kDarkColorS.primary,
                height: 1,
              ),
              bodyMedium: TextStyle(
                color: kDarkColorS.onBackground,
                height: 1,
              ),
              bodySmall: TextStyle(
                height: 1,
                color: kDarkColorS.secondary,
              ),
            ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorS,
        primaryColor: kColorS.primary,
        appBarTheme: const AppBarTheme().copyWith(
          foregroundColor: kColorS.onPrimary,
          backgroundColor: kColorS.primary,
        ),
        cardTheme: const CardTheme().copyWith(
          elevation: 0.5,
          color: kColorS.secondaryContainer,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 1,
            shadowColor: kColorS.background,
            backgroundColor: kColorS.primary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: kColorS.background,
            foregroundColor: kColorS.primary,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontSize: 20,
                color: kColorS.primary,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                color: kColorS.primary,
                height: 1,
              ),
              bodyMedium: TextStyle(
                color: kColorS.primary,
                height: 1,
              ),
              bodySmall: TextStyle(
                height: 1,
                color: kColorS.secondary,
              ),
            ),
      ),
      home: const Expenses(),
    ),
  );
}
