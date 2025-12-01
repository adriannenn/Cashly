import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load transactions for current user
  Future<void> loadTransactions(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await DatabaseService.instance.getTransactionsByUserId(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load transactions: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create transaction
  Future<bool> createTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await DatabaseService.instance.createTransaction(transaction);
      final newTransaction = transaction.copyWith(id: id);
      _transactions.insert(0, newTransaction);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create transaction: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update transaction
  Future<bool> updateTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseService.instance.updateTransaction(transaction);
      
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update transaction: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete transaction
  Future<bool> deleteTransaction(String transactionId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseService.instance.deleteTransaction(transactionId);
      _transactions.removeWhere((t) => t.id == transactionId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete transaction: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get transactions by type
  List<TransactionModel> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type.toLowerCase() == type.toLowerCase()).toList();
  }

  // Calculate total income
  double getTotalIncome() {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Calculate total expense
  double getTotalExpense() {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Get balance
  double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  // Get expenses by category
  Map<String, double> getExpensesByCategory() {
    Map<String, double> categoryMap = {};
    
    for (var transaction in _transactions) {
      if (transaction.isExpense) {
        categoryMap[transaction.category] = 
            (categoryMap[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryMap;
  }

  // Get income by category
  Map<String, double> getIncomeByCategory() {
    Map<String, double> categoryMap = {};
    
    for (var transaction in _transactions) {
      if (transaction.isIncome) {
        categoryMap[transaction.category] = 
            (categoryMap[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryMap;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
