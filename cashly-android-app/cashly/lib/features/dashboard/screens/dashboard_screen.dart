import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/budget_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_pie_chart.dart';
import '../widgets/income_expense_bar_chart.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/quick_action_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      final userId = authProvider.currentUser!.id!;
      
      await Future.wait([
        Provider.of<BudgetProvider>(context, listen: false).loadBudgets(userId),
        Provider.of<TransactionProvider>(context, listen: false).loadTransactions(userId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final greeting = Helpers.getGreeting();
            final name = authProvider.currentUser?.fullName.split(' ')[0] ?? 'User';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 
          ? _buildDashboardContent()
          : _selectedIndex == 1
              ? _buildStatsContent()
              : _buildAccountContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            const BalanceCard(),
            
            const SizedBox(height: 20),
            
            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickActionButton(
                    icon: Icons.add,
                    label: 'Add Income',
                    color: AppColors.success,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.addTransaction)
                          .then((_) => _loadData());
                    },
                  ),
                  QuickActionButton(
                    icon: Icons.remove,
                    label: 'Add Expense',
                    color: AppColors.error,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.addTransaction)
                          .then((_) => _loadData());
                    },
                  ),
                  QuickActionButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Budgets',
                    color: AppColors.accentYellow,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.budgetList);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Expense Breakdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Expense Breakdown',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const ExpensePieChart(),
            
            const SizedBox(height: 24),
            
            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.transactionList);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            
            const RecentTransactionsList(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          
          const SizedBox(height: 20),
          
          // Balance Summary
          const BalanceCard(),
          
          const SizedBox(height: 24),
          
          Text(
            'Income vs Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          const IncomeExpenseBarChart(),
          
          const SizedBox(height: 24),
          
          Text(
            'Expense by Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          const ExpensePieChart(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAccountContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          return Column(
            children: [
              const SizedBox(height: 20),
              
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryBlue,
                child: Text(
                  user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                user?.fullName ?? 'User',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: 30),
              
              // Menu Items
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
              
              _buildMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Budgets',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.budgetList);
                },
              ),
              
              _buildMenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Transactions',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.transactionList);
                },
              ),
              
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
              
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.about);
                },
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await authProvider.logout();
                      if (!mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryBlue),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
