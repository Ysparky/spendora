import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';

/// Widget for displaying the balance card
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    required this.period,
    required this.balance,
    required this.income,
    required this.expense,
    super.key,
  });

  final String period;
  final double balance;
  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: r'$');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  period,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currencyFormat.format(balance),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? AppColors.income : AppColors.expense,
                  ),
            ),
            const SizedBox(height: 16),
            Divider(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Income
                Expanded(
                  child: _AmountDisplay(
                    label: 'Income',
                    amount: income,
                    isIncome: true,
                  ),
                ),

                // Expense
                Expanded(
                  child: _AmountDisplay(
                    label: 'Expenses',
                    amount: expense,
                    isIncome: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying an amount (income or expense)
class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay({
    required this.label,
    required this.amount,
    required this.isIncome,
  });

  final String label;
  final double amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: r'$');
    final color = isIncome ? AppColors.income : AppColors.expense;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                icon,
                size: 16,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}
