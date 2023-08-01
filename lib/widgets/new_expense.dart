import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import './text_and_button.dart';
import './text_and_dropdown.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addData, {super.key});

  final void Function(Expense expense) addData;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  DateTime? _selectedDate;
  Category? _selectCate = Category.values[0];

  void _chooseDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    setState(() {
      _selectedDate = d;
    });
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        final alertWidget = Platform.isIOS
            ? CupertinoAlertDialog(
                content: const Text('請確保您輸入了有效的標題、消費價格、消費日期與消費類別。'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('確定'),
                  )
                ],
              )
            : AlertDialog(
                title: const Text('格式錯誤'),
                content: const Text('請確保您輸入了有效的標題、消費價格、消費日期與消費類別。'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('確定'),
                  )
                ],
              );
        return alertWidget;
      },
    );
  }

  void _submitData() {
    if (_titleController.text.trim().isEmpty ||
        int.tryParse(_priceController.text) == null ||
        int.parse(_priceController.text) <= 0 ||
        _selectedDate == null) {
      _showAlert();
      return;
    }

    widget.addData(Expense(
      title: _titleController.text.trim(),
      price: int.parse(_priceController.text),
      date: _selectedDate!,
      category: _selectCate!,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final priceWidget = TextField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: '消費價格',
        prefixText: 'NT\$',
      ),
      maxLength: 6,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      onSubmitted: (value) => _submitData(),
      textInputAction: TextInputAction.done,
    );

    final titleWidget = TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: '標題',
      ),
      textInputAction: TextInputAction.next,
      maxLength: 10,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '新增消費紀錄',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextAndDropdown(
                      label: '消費類別',
                      value: _selectCate,
                      items: Category.values,
                      onChanged: (value) {
                        setState(() {
                          _selectCate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextAndButton(
                      label: '消費日期',
                      value: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : '請選擇',
                      onPressed: _chooseDate,
                      icon: Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (orientation == Orientation.portrait) titleWidget,
          if (orientation == Orientation.portrait)
            Row(
              children: [
                Expanded(child: priceWidget),
                const SizedBox(width: 16),
                const Spacer()
              ],
            )
          else
            Row(
              children: [
                Expanded(child: titleWidget),
                const SizedBox(width: 16),
                SizedBox(width: 200, child: priceWidget),
              ],
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _submitData,
                  child: const Text('送出'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
