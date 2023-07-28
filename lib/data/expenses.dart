import '../models/expense.dart';

final List<Expense> expensesData = [
  Expense(
    title: '漢堡王花生堡套餐',
    price: 199,
    date: DateTime(2023, 07, 11, 04, 33),
    category: Category.food,
  ),
  Expense(
    title: 'udemy 課程',
    price: 390,
    date: DateTime(2023, 07, 22, 14, 13),
    category: Category.learn,
  ),
  Expense(
    title: '罐頭、植物介質、插座、杯蓋',
    price: 1384,
    date: DateTime(2023, 07, 18, 09, 31),
    category: Category.shopping,
  ),
  Expense(
    title: '避孕藥、止痛藥',
    price: 792,
    date: DateTime(2023, 07, 21, 05, 07),
    category: Category.medical,
  ),
  Expense(
    title: '義大利麵',
    price: 598,
    date: DateTime(2023, 07, 26, 05, 07),
    category: Category.food,
  ),
];
