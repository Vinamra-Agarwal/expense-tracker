import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const  NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _expenseController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;


  void _presentDayPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final chosenDate = await showDatePicker(
    context: context, 
    initialDate: now, 
    firstDate: firstDate, 
    lastDate: now
    );
    setState(() {
      _selectedDate = chosenDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_expenseController.text);
    final amountIsInvalid = (enteredAmount == null || enteredAmount <= 0);
    if (amountIsInvalid || _selectedDate == null || _titleController.text.trim().isEmpty) {
      showDialog(
      context: context, 
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please make sure you have entered expense title, amount and picked a date'),
          actions: [
            TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            }, 
            child: const Text('Okay')
            )
          ],
        );
      });
      return;
    }

    widget.onAddExpense(
    Expense(
      title: _titleController.text, 
      date: _selectedDate!, 
      amount: enteredAmount, 
      category: _selectedCategory)
    );

    Navigator.pop(context);
  }

  @override
  void dispose(){
    super.dispose();
    _titleController.dispose();
    _expenseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width > 450)
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                    child: TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Expense Title'),
                    ),
                    ), 
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField( 
                          controller: _expenseController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefix: Text('\$ '),
                            label: Text('Amount'),
                          ),
                        ),
                    ),
                  ],
                )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Expense Title'),
                    ),
                  ),
                if (width > 450)
                  Row(
                    children: [
                      DropdownButton(
                      value: _selectedCategory,
                      items: Category.values.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ) 
                        ),
                      ).toList(), 
                      onChanged: (value) {
                        if(value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }  
                      ),
                      const Spacer(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null ? 'No date Selected' : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDayPicker,
                              icon: const Icon(Icons.calendar_month)
                            ),
                          ],
                        ),
                    )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField( 
                            controller: _expenseController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefix: Text('\$ '),
                              label: Text('Amount'),
                            ),
                          ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null ? 'No date Selected' : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: _presentDayPicker,
                              icon: const Icon(Icons.calendar_month)
                            ),
                          ],
                        ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                if (width > 450)
                  Row(
                    children: [
                       const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')
                        ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      )
                    ],
                  )
                else
                  Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ) 
                        ),
                      ).toList(), 
                      onChanged: (value) {
                        if(value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      }  
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')
                        ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
    
  }
}