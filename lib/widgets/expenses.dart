import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();  
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: 'Flutter Course',
      date: DateTime.now(),
      amount: 19.99,
      category: Category.work,
    ),
    Expense(
      title: 'Movie',
      date: DateTime.now(),
      amount: 5.00,
      category: Category.leisure, 
    ),
  ];

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
    useSafeArea: true,
    isDismissible: true,
    isScrollControlled: true,
    
    context: context, 
    builder: (ctx) => NewExpense(onAddExpense: _addExpense) );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }
  
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration (seconds: 5),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
            _registeredExpense.insert(expenseIndex,expense);
          });
          }
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget maincontent = const Center(
      child: Text('No expense found, start adding some!')
    );

    if(_registeredExpense.isNotEmpty){
      maincontent = ExpensesList(expenses: _registeredExpense,onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(
            child: maincontent,
          )
        ],
      ) : Row(
        children: [
          Expanded(
            child: Chart(expenses: _registeredExpense),
          ),
          Expanded(
            child: maincontent,
          )
        ],
      )
    );
  }
}