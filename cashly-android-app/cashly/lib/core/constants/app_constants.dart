class AppConstants {
  // App Info
  static const String appName = 'Cashly';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your personal budget and finance tracker';
  
  // Database
  static const String databaseName = 'cashly.db';
  static const int databaseVersion = 1;
  
  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
  
  // API Endpoints
  static const String baseUrl = 'https://api.cashly.com/v1';
  static const String authEndpoint = '/auth';
  static const String budgetEndpoint = '/budgets';
  static const String transactionEndpoint = '/transactions';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxBudgetNameLength = 50;
  static const int maxTransactionNoteLength = 200;
  
  // Categories
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Groceries',
    'Others'
  ];
  
  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Refund',
    'Others'
  ];
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy hh:mm a';
}
