import 'package:flutter/material.dart';

import '../data/expenses.dart';
import '../models/expense.dart';
import './expenses_list/expenses_list.dart';
import './new_expense.dart';
import './chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  void _addData(Expense data) {
    setState(() {
      expensesData.add(data);
    });
  }

  get _sortExpensesData {
    final data = List.of(expensesData);
    data.sort((a, b) =>
        b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
    return data;
  }

  void _removeExpenses(Expense expense) {
    setState(() {
      expensesData.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已刪除 ${expense.title} 消費。'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: '復原',
            onPressed: () {
              setState(() {
                expensesData.add(expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('目前沒有任何消費紀錄，請添加項目。'),
    );

    if (expensesData.isNotEmpty) {
      mainContent = Expanded(
        child: ExpensesList(
          _sortExpensesData,
          _removeExpenses,
        ),
      );
    }

    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(child: NewExpense(_addData)),
                ),
                isScrollControlled: true,
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            child: isWideScreen
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Chart',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Chart(_sortExpensesData),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.55,
                        child: Column(
                          children: [
                            Text(
                              'Records',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            mainContent,
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        'Chart',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Chart(_sortExpensesData),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Records',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      mainContent,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
