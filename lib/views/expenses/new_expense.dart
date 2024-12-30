import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final formatter = DateFormat.yMd();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///find how much space the keyboard takes
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    ///alternate way to set constraints on portrait/landscape
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            /// add extra padding when keyboard is up
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)

                  ///landscape mode
                  _buildTopAreaLandscape()
                else

                  ///portrait mode
                  _buildTopAreaPortrait(),
                if (width >= 600)

                  ///landscape mode
                  _buildMiddleAreaLandscape()
                else

                  ///portrait mode
                  _buildMiddleAreaPortrait(),
                const SizedBox(height: 16),
                if (width >= 600)

                  ///landscape mode
                  _buildBottomAreaLandscape(context)
                else

                  ///portrait mode
                  _buildBottomAreaPortrait(context)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBottomAreaPortrait(BuildContext context) {
    return Row(
      children: [
        ///dropdown button
        DropdownButton(
          value: _selectedCategory,

          ///using Category enum as dropdown values
          items: Category.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
        const Spacer(),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: _submitExpenseData,
          child: const Text("Save Expense"),
        )
      ],
    );
  }

  Widget _buildBottomAreaLandscape(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: _submitExpenseData,
          child: const Text("Save Expense"),
        )
      ],
    );
  }

  Widget _buildMiddleAreaPortrait() {
    return Row(
      children: [
        Expanded(
          ///price input
          child: TextField(
            controller: _amountController,
            decoration: const InputDecoration(label: Text("Amount"), prefixText: '\$ '),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///label next to date picker
              Text(
                _selectedDate == null ? "No date selected" : formatter.format(_selectedDate!),
              ),

              ///date picker
              IconButton(
                onPressed: _presentDatePicker,
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMiddleAreaLandscape() {
    return Row(
      children: [
        DropdownButton(
          value: _selectedCategory,

          ///using Category enum as dropdown values
          items: Category.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///label next to date picker
              Text(
                _selectedDate == null ? "No date selected" : formatter.format(_selectedDate!),
              ),

              ///date picker
              IconButton(
                onPressed: _presentDatePicker,
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTopAreaPortrait() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(label: Text("Title")),
      maxLength: 50,
    );
  }

  Widget _buildTopAreaLandscape() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          ///price input
          child: TextField(
            controller: _amountController,
            decoration: const InputDecoration(label: Text("Amount"), prefixText: '\$ '),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  void _presentDatePicker() async {
    final currentDate = DateTime.now();
    final firstDate = DateTime(currentDate.year - 1, currentDate.month, currentDate.day);
    //
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: currentDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Confirm'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content:
              const Text('Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Confirm'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    // tryParse('Hello) => null, tryParse('1.12') => 1.12
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.addExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }
}
