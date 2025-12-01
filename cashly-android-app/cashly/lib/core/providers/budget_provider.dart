import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../services/database_service.dart';

class BudgetProvider with ChangeNotifier {
  List<BudgetModel> _budgets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BudgetModel> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load budgets for current user
  Future<void> loadBudgets(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _budgets = await DatabaseService.instance.getBudgetsByUserId(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load budgets: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create budget
  Future<bool> createBudget(BudgetModel budget) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await DatabaseService.instance.createBudget(budget);
      final newBudget = budget.copyWith(id: id);
      _budgets.insert(0, newBudget);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create budget: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update budget
  Future<bool> updateBudget(BudgetModel budget) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseService.instance.updateBudget(budget);
      
      final index = _budgets.indexWhere((b) => b.id == budget.id);
      if (index != -1) {
        _budgets[index] = budget;
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update budget: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete budget
  Future<bool> deleteBudget(String budgetId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseService.instance.deleteBudget(budgetId);
      _budgets.removeWhere((b) => b.id == budgetId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete budget: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get budget by ID
  BudgetModel? getBudgetById(String id) {
    try {
      return _budgets.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // Calculate total budget amount
  double getTotalBudgetAmount() {
    return _budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
