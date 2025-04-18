import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Widget for filtering transactions
class TransactionFilterBar extends StatelessWidget {
  /// Constructor
  const TransactionFilterBar({
    required this.selectedType,
    required this.onTypeChanged,
    required this.onCategorySelected,
    required this.onDateRangeSelected,
    required this.onClearFilters,
    super.key,
  });

  /// Currently selected transaction type
  final TransactionType selectedType;

  /// Callback when transaction type changes
  final Function(TransactionType) onTypeChanged;

  /// Callback when a category is selected
  final Function(String) onCategorySelected;

  /// Callback when a date range is selected
  final Function(DateTimeRange) onDateRangeSelected;

  /// Callback to clear all filters
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Type filter
          Row(
            children: [
              _buildTypeFilterChip(
                context,
                TransactionType.expense,
                'Expenses',
                Icons.arrow_downward,
                AppColors.expense,
              ),
              const SizedBox(width: 8),
              _buildTypeFilterChip(
                context,
                TransactionType.income,
                'Income',
                Icons.arrow_upward,
                AppColors.income,
              ),
              const SizedBox(width: 8),
              _buildTypeFilterChip(
                context,
                TransactionType.expense,
                'All',
                Icons.list,
                AppColors.neutral,
                isAll: true,
              ),
              const Spacer(),
              // Clear filters button
              TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Advanced filters
          Row(
            children: [
              // Category filter
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.category),
                  label: const Text('Category'),
                  onPressed: () => _showCategoryPicker(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Date range filter
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: const Text('Date Range'),
                  onPressed: () => _showDateRangePicker(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilterChip(
    BuildContext context,
    TransactionType type,
    String label,
    IconData icon,
    Color color, {
    bool isAll = false,
  }) {
    final isSelected =
        isAll ? selectedType == type : selectedType == type && !isAll;

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Theme.of(context).colorScheme.onPrimary : color,
      ),
      onSelected: (selected) {
        if (selected) {
          onTypeChanged(type);
        }
      },
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    // Pre-defined categories
    final categories = [
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Entertainment',
      'Health',
      'Other',
    ];

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Select Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final color =
                        AppColors.categoryColors[category.toLowerCase()] ??
                            AppColors.categoryColors['other']!;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(
                          index == 0
                              ? Icons.restaurant
                              : index == 1
                                  ? Icons.directions_car
                                  : index == 2
                                      ? Icons.shopping_cart
                                      : index == 3
                                          ? Icons.receipt
                                          : index == 4
                                              ? Icons.movie
                                              : index == 5
                                                  ? Icons.medical_services
                                                  : Icons.category,
                          color: color,
                        ),
                      ),
                      title: Text(category),
                      onTap: () {
                        onCategorySelected(category);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      onDateRangeSelected(pickedDateRange);
    }
  }
}
