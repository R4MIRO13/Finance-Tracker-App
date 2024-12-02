import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class SharedPreferencesHelper {
  static const String _transactionsKey = 'transactions';
  static const String _budgetsKey = 'budgets';
  static const String _darkModeKey = 'darkMode';

  static Future<void> addTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList(_transactionsKey) ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList(_transactionsKey, transactions);
  }

  static Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionsStringList = prefs.getStringList(_transactionsKey);
    if (transactionsStringList == null || transactionsStringList.isEmpty) {
      return [];
    }
    return transactionsStringList
        .map((transactionStr) => Transaction.fromJson(jsonDecode(transactionStr)))
        .toList();
  }

  static Future<void> addBudget(Budget budget) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> budgets = prefs.getStringList(_budgetsKey) ?? [];
    budgets.add(jsonEncode(budget.toJson()));
    await prefs.setStringList(_budgetsKey, budgets);
  }

  static Future<List<Budget>> getBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? budgetsStringList = prefs.getStringList(_budgetsKey);
    if (budgetsStringList == null || budgetsStringList.isEmpty) {
      return [];
    }
    return budgetsStringList
        .map((budgetStr) => Budget.fromJson(jsonDecode(budgetStr)))
        .toList();
  }

  static Future<void> updateBudgetSpent(String category, double newSpent) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> budgetsStringList = prefs.getStringList(_budgetsKey) ?? [];
    List<String> updatedBudgets = budgetsStringList.map((budgetStr) {
      final budget = Budget.fromJson(jsonDecode(budgetStr));
      if (budget.category == category) {
        budget.spent = newSpent;
      }
      return jsonEncode(budget.toJson());
    }).toList();
    await prefs.setStringList(_budgetsKey, updatedBudgets);
  }

  static Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
  }

  static Future<void> clearBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_budgetsKey);
  }

  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }
}
