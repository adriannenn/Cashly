import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final expensesByCategory = transactionProvider.getExpensesByCategory();
        
        if (expensesByCategory.isEmpty) {
          return Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No expense data available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Container(
          height: 350,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: _generateSections(expensesByCategory),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _buildLegend(expensesByCategory),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _generateSections(Map<String, double> data) {
    final total = data.values.fold(0.0, (sum, value) => sum + value);
    int colorIndex = 0;
    
    return data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = AppColors.chartColors[colorIndex % AppColors.chartColors.length];
      colorIndex++;
      
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: color,
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, double> data) {
    int colorIndex = 0;
    
    return data.entries.map((entry) {
      final color = AppColors.chartColors[colorIndex % AppColors.chartColors.length];
      colorIndex++;
      
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            entry.key,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      );
    }).toList();
  }
}
