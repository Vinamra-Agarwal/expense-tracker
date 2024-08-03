import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();

enum Category { food, leisure, work, travel }

const categoryIcons = {
  Category.food : Icons.lunch_dining,
  Category.leisure : Icons.movie,
  Category.work : Icons.work,
  Category.travel : Icons.flight_takeoff,
};

class Expense {
  Expense({
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
  }) : id = uuid.v4();

  final String title;
  final String id;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
    :expenses = allExpense
      .where((expense) => expense.category == category)
      .toList();
      
  final Category category;
  final List<Expense> expenses;
  
  double get totalExpenses {
    double sum = 0;

    for(final expense in expenses){
      sum += expense.amount;
    }

  return sum;
  }

}