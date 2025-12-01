import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/budget_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const textTypeNullable = 'TEXT';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        full_name $textType,
        email $textType UNIQUE,
        password $textType,
        profile_image $textTypeNullable,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id $idType,
        user_id $textType,
        name $textType,
        amount $realType,
        category $textType,
        period $textType,
        start_date $textType,
        end_date $textType,
        description $textTypeNullable,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        user_id $textType,
        type $textType,
        amount $realType,
        category $textType,
        title $textType,
        note $textTypeNullable,
        date $textType,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_budgets_user_id ON budgets(user_id)');
    await db.execute('CREATE INDEX idx_transactions_user_id ON transactions(user_id)');
    await db.execute('CREATE INDEX idx_transactions_date ON transactions(date)');
  }

  // User CRUD Operations
  Future<String> createUser(UserModel user) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final userWithId = user.copyWith(id: id);
    await db.insert('users', userWithId.toMap());
    return id;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return db.update(
      'users',
      user.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Budget CRUD Operations
  Future<String> createBudget(BudgetModel budget) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final budgetWithId = budget.copyWith(id: id);
    await db.insert('budgets', budgetWithId.toMap());
    return id;
  }

  Future<List<BudgetModel>> getBudgetsByUserId(String userId) async {
    final db = await database;
    final maps = await db.query(
      'budgets',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => BudgetModel.fromMap(map)).toList();
  }

  Future<BudgetModel?> getBudgetById(String id) async {
    final db = await database;
    final maps = await db.query(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return BudgetModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBudget(BudgetModel budget) async {
    final db = await database;
    return db.update(
      'budgets',
      budget.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(String id) async {
    final db = await database;
    return db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction CRUD Operations
  Future<String> createTransaction(TransactionModel transaction) async {
    final db = await database;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final transactionWithId = transaction.copyWith(id: id);
    await db.insert('transactions', transactionWithId.toMap());
    return id;
  }

  Future<List<TransactionModel>> getTransactionsByUserId(String userId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<List<TransactionModel>> getTransactionsByUserIdAndDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'user_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [userId, startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'date DESC',
    );
    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return db.update(
      'transactions',
      transaction.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Analytics Methods
  Future<double> getTotalIncomeByUserId(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE user_id = ? AND type = ?',
      [userId, 'income'],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalExpenseByUserId(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE user_id = ? AND type = ?',
      [userId, 'expense'],
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<Map<String, double>> getExpensesByCategory(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM transactions WHERE user_id = ? AND type = ? GROUP BY category',
      [userId, 'expense'],
    );
    
    Map<String, double> expenses = {};
    for (var row in result) {
      expenses[row['category'] as String] = row['total'] as double;
    }
    return expenses;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
