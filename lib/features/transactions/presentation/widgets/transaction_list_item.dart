import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Widget to display an individual transaction in the list
class TransactionListItem extends StatelessWidget {
  /// Constructor
  const TransactionListItem({
    required this.transaction,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  /// The transaction to display
  final TransactionModel transaction;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// Callback when edit action is triggered
  final VoidCallback? onEdit;

  /// Callback when delete action is triggered
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: r'$');
    final colorScheme = Theme.of(context).colorScheme;

    // Determine colors based on transaction type
    final amountColor = transaction.type == TransactionType.expense
        ? AppColors.expense
        : AppColors.income;

    // Format the amount with the correct sign and currency
    final formattedAmount = transaction.type == TransactionType.expense
        ? '- ${currencyFormat.format(transaction.amount)}'
        : '+ ${currencyFormat.format(transaction.amount)}';

    // Get icon for the category
    var categoryIcon = Icons.shopping_bag;
    switch (transaction.category.toLowerCase()) {
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

    // Get color for the category
    final categoryColor =
        AppColors.categoryColors[transaction.category.toLowerCase()] ??
            AppColors.categoryColors['other']!;

    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        color: colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          Icons.edit,
          color: colorScheme.onPrimary,
        ),
      ),
      secondaryBackground: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: colorScheme.onError,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete action
          if (onDelete != null) {
            onDelete?.call();
            return false; // Don't dismiss automatically, let the parent handle it
          }
        } else if (direction == DismissDirection.startToEnd) {
          // Edit action
          if (onEdit != null) {
            onEdit?.call();
          }
          return false; // Don't actually dismiss the item
        }
        return false;
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 16),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.description ?? transaction.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                formattedAmount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
