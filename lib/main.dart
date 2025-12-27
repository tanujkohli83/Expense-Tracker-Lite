import 'package:flutter/material.dart';
import 'package:expensetrackerlite/Screens/DashBoard.dart';
import 'Screens/AddExpense.dart';

void main() {
  runApp(const ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Specifies the first screen
      routes: {
        '/': (context) => Dashboard(),
        '/addExpense': (context) => Addexpense(),
      },
    );
  }
}


