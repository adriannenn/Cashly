import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_service.dart';
import 'database_service.dart';

class SyncService {
  static final SyncService instance = SyncService._init();
  final ApiService _apiService = ApiService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;
  bool _isSyncing = false;

  SyncService._init();

  // Check if device is connected to internet
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Sync all data for a user
  Future<bool> syncUserData(String userId) async {
    if (_isSyncing) return false;
    
    try {
      _isSyncing = true;
      
      // Check internet connection
      if (!await hasInternetConnection()) {
        return false;
      }

      // Get local data
      final budgets = await _databaseService.getBudgetsByUserId(userId);
      final transactions = await _databaseService.getTransactionsByUserId(userId);

      // Sync with server
      await _apiService.syncData(
        userId: userId,
        budgets: budgets,
        transactions: transactions,
      );

      return true;
    } catch (e) {
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  // Auto-sync when internet is available
  Future<void> setupAutoSync(String userId) async {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await syncUserData(userId);
      }
    });
  }

  bool get isSyncing => _isSyncing;
}
