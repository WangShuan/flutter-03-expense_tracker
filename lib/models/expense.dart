import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category {
  food,
  shopping,
  medical,
  learn,
  others,
}

const cateIcon = {
  Category.food: Icons.restaurant,
  Category.learn: Icons.menu_book,
  Category.medical: Icons.medical_services,
  Category.shopping: Icons.store,
  Category.others: Icons.category,
};

class Expense {
  Expense({
    required this.title,
    required this.price,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final int price;
  final DateTime date;
  final Category category;

  get formatterTime {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket(this.category, this.expenses);

  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.fromCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((element) => element.category == category)
            .toList();

  int get totalExpenses {
    int sum = 0;
    for (final e in expenses) {
      sum += e.price;
    }

    return sum;
  }
}
