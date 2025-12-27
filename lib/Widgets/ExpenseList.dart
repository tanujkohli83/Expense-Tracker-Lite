import 'package:expensetrackerlite/ExpenseDataModel.dart';
import 'package:flutter/material.dart';

class Expenselist extends StatelessWidget {
  final List<Expense> expense_list;

  const Expenselist({super.key, required this.expense_list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expense_list.length,
      itemBuilder: (context, index) {
        final expense = expense_list[index];

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 60,
          child: Card(
            color: Color(0xff244730),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expense.expense_title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    expense.amount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
