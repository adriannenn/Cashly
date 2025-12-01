import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/budget_model.dart';
import '../models/transaction_model.dart';

class ApiService {
  static final ApiService instance = ApiService._init();
  late Dio _dio;

  ApiService._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add authentication token if available
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  // Authentication APIs
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConstants.authEndpoint}/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConstants.authEndpoint}/register',
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Budget APIs
  Future<List<BudgetModel>> getBudgets(String userId) async {
    try {
      final response = await _dio.get(
        AppConstants.budgetEndpoint,
        queryParameters: {'user_id': userId},
      );
      
      final List<dynamic> data = response.data['budgets'];
      return data.map((json) => BudgetModel.fromMap(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BudgetModel> createBudget(BudgetModel budget) async {
    try {
      final response = await _dio.post(
        AppConstants.budgetEndpoint,
        data: budget.toJson(),
      );
      return BudgetModel.fromMap(response.data['budget']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BudgetModel> updateBudget(BudgetModel budget) async {
    try {
      final response = await _dio.put(
        '${AppConstants.budgetEndpoint}/${budget.id}',
        data: budget.toJson(),
      );
      return BudgetModel.fromMap(response.data['budget']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    try {
      await _dio.delete('${AppConstants.budgetEndpoint}/$budgetId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Transaction APIs
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final response = await _dio.get(
        AppConstants.transactionEndpoint,
        queryParameters: {'user_id': userId},
      );
      
      final List<dynamic> data = response.data['transactions'];
      return data.map((json) => TransactionModel.fromMap(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await _dio.post(
        AppConstants.transactionEndpoint,
        data: transaction.toJson(),
      );
      return TransactionModel.fromMap(response.data['transaction']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await _dio.put(
        '${AppConstants.transactionEndpoint}/${transaction.id}',
        data: transaction.toJson(),
      );
      return TransactionModel.fromMap(response.data['transaction']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _dio.delete('${AppConstants.transactionEndpoint}/$transactionId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Analytics APIs
  Future<Map<String, dynamic>> getAnalytics(String userId) async {
    try {
      final response = await _dio.get(
        '/analytics',
        queryParameters: {'user_id': userId},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Sync APIs
  Future<void> syncData({
    required String userId,
    List<BudgetModel>? budgets,
    List<TransactionModel>? transactions,
  }) async {
    try {
      await _dio.post(
        '/sync',
        data: {
          'user_id': userId,
          'budgets': budgets?.map((b) => b.toJson()).toList(),
          'transactions': transactions?.map((t) => t.toJson()).toList(),
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (error.response?.statusCode == 404) {
          return 'Resource not found.';
        } else if (error.response?.statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed with status: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error. Please check your connection.';
    }
  }
}
