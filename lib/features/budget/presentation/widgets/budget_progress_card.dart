import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/budget/domain/models/budget_model.dart';

/// Widget to display a budget progress card
class BudgetProgressCard extends StatelessWidget {
  /// Constructor
  const BudgetProgressCard({
    required this.budget,
    this.onTap,
    super.key,
  });

  /// The budget to display
  final BudgetModel budget;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: r'$');
    final colorScheme = Theme.of(context).colorScheme;

    // Determine progress color based on percentage spent
    Color progressColor;
    if (budget.percentSpent >= 100) {
      progressColor = AppColors.expense; // Over budget
    } else if (budget.percentSpent >= 80) {
      progressColor = Colors.orange; // Approaching limit
    } else {
      progressColor = AppColors.income; // Healthy
    }

    // Format the amounts
    final formattedBudget = currencyFormat.format(budget.amount);
    final formattedSpent = currencyFormat.format(budget.spent);
    final formattedRemaining = currencyFormat.format(budget.remaining);

    // Get color for the category
    final categoryColor =
        AppColors.categoryColors[budget.category.toLowerCase()] ??
            AppColors.categoryColors['other']!;

    // Get icon for the category
    IconData categoryIcon;
    switch (budget.category.toLowerCase()) {
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

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and period
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getDisplayCategory(budget.category),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  // Period badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      budget.period.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Budget amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Budget amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        formattedBudget,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  // Spent amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Spent',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        formattedSpent,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: budget.isOverBudget
                                      ? AppColors.expense
                                      : null,
                                ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: budget.percentSpent / 100,
                  backgroundColor: colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: 12),

              // Remaining and percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remaining amount
                  Text(
                    'Remaining: $formattedRemaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: budget.isOverBudget
                              ? AppColors.expense
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  // Percentage spent
                  Text(
                    '${budget.percentSpent.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: progressColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get display-friendly category name
  String _getDisplayCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'Food & Drinks';
      case 'transport':
        return 'Transportation';
      case 'shopping':
        return 'Shopping';
      case 'bills':
        return 'Bills & Utilities';
      case 'entertainment':
        return 'Entertainment';
      case 'health':
        return 'Healthcare';
      default:
        // Capitalize first letter
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }
}
