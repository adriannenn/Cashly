import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light Mode'),
                      subtitle: const Text('Use light theme'),
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      activeColor: AppColors.primaryBlue,
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Use dark theme'),
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      activeColor: AppColors.primaryBlue,
                    ),
                    const Divider(height: 1),
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      subtitle: const Text('Follow system theme'),
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                      activeColor: AppColors.primaryBlue,
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 30),
          
          // Notifications Section
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Budget Alerts'),
                  subtitle: const Text('Get notified when exceeding budget'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification settings
                  },
                  activeColor: AppColors.primaryBlue,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Transaction Reminders'),
                  subtitle: const Text('Daily reminder to log transactions'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement notification settings
                  },
                  activeColor: AppColors.primaryBlue,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Data & Privacy Section
          Text(
            'Data & Privacy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download_outlined),
                  title: const Text('Export Data'),
                  subtitle: const Text('Download your data as CSV'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text('Backup & Restore'),
                  subtitle: const Text('Manage your data backup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Backup feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text(
                    'Clear All Data',
                    style: TextStyle(color: AppColors.error),
                  ),
                  subtitle: const Text('Permanently delete all data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear All Data'),
                        content: const Text(
                          'This will permanently delete all your budgets, transactions, and account data. This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data cleared successfully'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // App Version
          Center(
            child: Column(
              children: [
                Text(
                  'Cashly Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with Flutter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
