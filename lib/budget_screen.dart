import 'package:flutter/material.dart';
import 'shared_preferences_helper.dart';
import 'models.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  _loadBudgets() async {
    budgets = await SharedPreferencesHelper.getBudgets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Budgets"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: budgets.isEmpty
            ? Center(child: Text("No budgets available"))
            : ListView.builder(
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            final budget = budgets[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              child: ListTile(
                title: Text(
                  budget.category,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '\$${budget.spent} of \$${budget.limit}',
                  style: TextStyle(color: budget.spent > budget.limit ? Colors.red : Colors.green),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
