import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/budget/screens/budget_list_screen.dart';
import '../../features/budget/screens/add_budget_screen.dart';
import '../../features/transactions/screens/transaction_list_screen.dart';
import '../../features/transactions/screens/add_transaction_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/about/screens/about_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String budgetList = '/budgets';
  static const String addBudget = '/add-budget';
  static const String editBudget = '/edit-budget';
  static const String transactionList = '/transactions';
  static const String addTransaction = '/add-transaction';
  static const String editTransaction = '/edit-transaction';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      budgetList: (context) => const BudgetListScreen(),
      addBudget: (context) => const AddBudgetScreen(),
      transactionList: (context) => const TransactionListScreen(),
      addTransaction: (context) => const AddTransactionScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
      about: (context) => const AboutScreen(),
    };
  }
}
