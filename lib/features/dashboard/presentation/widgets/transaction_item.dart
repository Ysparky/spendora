import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Widget for displaying a transaction item
class TransactionItem extends StatelessWidget {
  const TransactionItem({
    required this.transaction,
    required this.onTap,
    super.key,
  });

  final Map<String, dynamic> transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: r'$');
    final isExpense = transaction['type'] == TransactionType.expense;
    final category = transaction['category'] as String;

    // Get icon for the category
    IconData categoryIcon;
    switch (category) {
      case 'food':
        categoryIcon = Icons.restaurant;
      case 'transport':
        categoryIcon = Icons.directions_car;
      case 'shopping':
        categoryIcon = Icons.shopping_cart;
      case 'bills':
        categoryIcon = Icons.receipt;
      case 'entertainment':
        categoryIcon = Icons.movie;
      case 'health':
        categoryIcon = Icons.medical_services;
      default:
        categoryIcon = Icons.category;
    }

    final color = AppColors.categoryColors[category] ??
        AppColors.categoryColors['other']!;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            categoryIcon,
            color: color,
          ),
        ),
        title: Text(
          transaction['title'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          _formatDate(transaction['date'] as DateTime),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          isExpense
              ? '- ${currencyFormat.format(transaction['amount'])}'
              : '+ ${currencyFormat.format(transaction['amount'])}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isExpense ? AppColors.expense : AppColors.income,
              ),
        ),
        onTap: onTap,
      ),
    );
  }

  /// Format the date in a user-friendly way
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
