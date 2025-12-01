import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // App Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // App Name
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Version
            Text(
              'Version ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Cashly',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppConstants.appDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cashly helps you manage your finances efficiently by tracking your income, expenses, and budgets. With beautiful visualizations and intuitive interface, staying on top of your finances has never been easier.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      Icons.account_balance_wallet_outlined,
                      'Budget Management',
                      'Create and manage multiple budgets',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.receipt_long_outlined,
                      'Transaction Tracking',
                      'Log all your income and expenses',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.pie_chart_outline,
                      'Visual Analytics',
                      'Beautiful charts and graphs',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.dark_mode_outlined,
                      'Dark Mode',
                      'Easy on the eyes, day or night',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      Icons.security_outlined,
                      'Secure & Private',
                      'Your data stays on your device',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Developer Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Developer',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Built with Flutter and Dart',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Following modern app development best practices with clean architecture, OOP principles, and comprehensive CRUD operations.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Contact Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactButton(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email: support@cashlyapp.com'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                _buildContactButton(
                  icon: Icons.web_outlined,
                  label: 'Website',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Visit: www.cashlyapp.com'),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Copyright
            Text(
              '© 2025 Cashly. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
