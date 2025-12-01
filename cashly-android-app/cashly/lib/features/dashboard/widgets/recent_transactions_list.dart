import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final transactions = transactionProvider.transactions.take(5).toList();
        
        if (transactions.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final isIncome = transaction.isIncome;
            final color = isIncome ? AppColors.success : AppColors.error;
            final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                title: Text(transaction.title),
                subtitle: Text(
                  '${transaction.category} • ${Helpers.formatDate(transaction.date)}',
                ),
                trailing: Text(
                  '${isIncome ? '+' : '-'}${Helpers.formatCurrency(transaction.amount)}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
