import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

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

  void _submitData() {
    if (_titleController.text.trim().isEmpty ||
        int.tryParse(_priceController.text) == null ||
        int.parse(_priceController.text) <= 0 ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
        ),
      );
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
    final textStyle = TextStyle(
      fontSize: 14,
      color: Theme.of(context).primaryColor,
    );
    final labelStyle = TextStyle(
      fontSize: 14,
      color: Theme.of(context).brightness == Brightness.dark
          ? kDarkColorS.onPrimaryContainer
          : const Color.fromARGB(255, 55, 55, 55),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '新增消費紀錄',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '消費類別',
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? kDarkColorS.onPrimary
                            : kColorS.onPrimary,
                      ),
                      child: DropdownButton<Category>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        items: Category.values
                            .map(
                              (e) => DropdownMenuItem<Category>(
                                value: e,
                                child: Row(
                                  children: [
                                    Icon(
                                      cateIcon[e],
                                      size: 16,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      cateZhName[e].toString(),
                                      style: textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: _selectCate,
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectCate = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '消費日期',
                      style: labelStyle,
                    ),
                    TextButton.icon(
                      onPressed: _chooseDate,
                      style: TextButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? kDarkColorS.onPrimary
                                : kColorS.onPrimary,
                        alignment: Alignment.centerLeft,
                      ),
                      label: _selectedDate != null
                          ? Text(
                              DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate!)
                                  .toString(),
                              style: textStyle,
                              textAlign: TextAlign.left,
                            )
                          : Text(
                              '請選擇',
                              style: textStyle,
                              textAlign: TextAlign.left,
                            ),
                      icon: Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelStyle: labelStyle,
              labelText: '標題',
              floatingLabelStyle: const TextStyle(),
              contentPadding: const EdgeInsets.all(0),
            ),
            maxLength: 12,
            style: const TextStyle(
              height: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelStyle: labelStyle,
                    labelText: '消費價格',
                    prefixText: 'NT\$',
                    floatingLabelStyle: const TextStyle(),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const Spacer()
            ],
          ),
          const SizedBox(
            height: 16,
          ),
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
              const SizedBox(
                width: 16,
              ),
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
