import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_transaction_screen.dart';
import 'settings_screen.dart';
import 'shared_preferences_helper.dart';
import 'models.dart';
import 'transaction_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  _loadTransactions() async {
    try {
      transactions = await SharedPreferencesHelper.getTransactions();
      _calculateTotalBalance();
      setState(() {});
    } catch (e) {
      print('Error in _loadTransactions: $e');
    }
  }

  _calculateTotalBalance() {
    totalBalance = transactions.fold(0.0, (sum, transaction) {
      return transaction.type == 'Income' ? sum + transaction.amount : sum - transaction.amount;
    });
  }

  List<PieChartSectionData> _generateChartSections() {
    double incomeTotal = transactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    double expenseTotal = transactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return [
      PieChartSectionData(
        value: incomeTotal,
        color: Colors.green,
        title: 'Income',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: expenseTotal,
        color: Colors.red,
        title: 'Expense',
        titleStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];
  }

  _resetData() async {
    try {
      await SharedPreferencesHelper.clearTransactions();
      await SharedPreferencesHelper.clearBudgets();
      setState(() {
        transactions.clear();
        totalBalance = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data has been reset successfully')),
      );
    } catch (e) {
      print('Error in _resetData: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    onThemeChanged: widget.onThemeChanged,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetData,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Balance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Card(
                  margin: const EdgeInsets.only(top: 10),
                  elevation: 5,
                  color: Colors.teal.shade50.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '\$ ${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Transaction Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 200,
                  child: PieChart(PieChartData(
                    sections: _generateChartSections(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  )),
                ),
                const SizedBox(height: 20),
                const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: Text('No transactions available'))
                      : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(top: 10),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            transactions[index].description,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailScreen(transaction: transactions[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (result != null) {
            _loadTransactions();
          }
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
