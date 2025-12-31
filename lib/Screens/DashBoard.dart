import 'package:expensetrackerlite/ExpenseDataModel.dart';
import 'package:expensetrackerlite/data/local/db_helper.dart';
import 'package:flutter/material.dart';
import '../Widgets/ExpenseList.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Expense> expenseList = [];
  double totalBudget = 0.0;
  double remainingBalance = 0.0;
  String expenseReason = "";
  double expenseAmount = 0.0;
  DBHelper? dbRef;
  final TextEditingController _bugetTextController = TextEditingController();
  final TextEditingController _addExpenseController = TextEditingController();
  final TextEditingController _addReasonController = TextEditingController();
  List<Map<String, dynamic>> amt = [];
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    // expenseList.add(Expense("cafe", 1000));
    // expenseList.add(Expense("Travel", 2000));
    dbRef = DBHelper.getInstance();
    loadBudget();
    loadExpenses();
  }

  Future<void> loadBudget() async {
    final data = await dbRef!.getBudgetData();

    if (data.isNotEmpty) {
      totalBudget = data.first["budgetAmount"];
    } else {
      totalBudget = 0.0;
    }

    setState(() {});
  }

  Future<void> loadExpenses() async {
    expenses = await dbRef!.getExpenseData();
    setState(() {});
  }

  @override
  void dispose() {
    _bugetTextController.dispose();
    _addExpenseController.dispose();
    _addExpenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        centerTitle: true,
        backgroundColor: Color(0xFF112217),
      ),
      backgroundColor: Color(0xFF112217),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Overview",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                color: Color(0xff244730),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Balance",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              // add dialog box to add expense
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Color(0xff142214),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    title: Text(
                                      "Add Your Monthly Budget",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: TextField(
                                      controller: _bugetTextController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: "Enter Budget",
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        enabled: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final value =
                                              double.tryParse(
                                                _bugetTextController.text,
                                              ) ??
                                              0.0;

                                          await dbRef!.addBudget(amt: value);

                                          await loadBudget(); // load from DB and setState() inside it

                                          _bugetTextController.clear();

                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.add_box_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Expanded(
                        child: Text(
                          "₹ $totalBudget",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // add expenses
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xff142214),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                          content: SizedBox(
                            height: 130,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _addReasonController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter Reason in One Word",
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _addExpenseController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter Amount",
                                    hintStyle: TextStyle(color: Colors.white),
                                    enabled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final reason = _addReasonController.text;
                                final amount =
                                    double.tryParse(
                                      _addExpenseController.text,
                                    ) ??
                                    0.0;

                                if (amount <= 0 || reason.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Enter valid reason & amount",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                await dbRef!.addExpense(
                                  res: reason,
                                  amt: amount,
                                );

                                await loadExpenses(); // reload UI

                                Navigator.pop(context);
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expenselist(expense_list: expenseList),
          ],
        ),
      ),
    );
  }
}
