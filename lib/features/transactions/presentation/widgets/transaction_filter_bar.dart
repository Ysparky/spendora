import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Enum for internal special type handling
enum _FilterBarType {
  expense,
  income,
  all,
}

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
  final void Function(TransactionType) onTypeChanged;

  /// Callback when a category is selected
  final void Function(String) onCategorySelected;

  /// Callback when a date range is selected
  final void Function(DateTimeRange) onDateRangeSelected;

  /// Callback to clear all filters
  final VoidCallback onClearFilters;

  /// Map TransactionType to internal enum
  _FilterBarType _mapToFilterBarType(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return _FilterBarType.expense;
      case TransactionType.income:
        return _FilterBarType.income;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if "All" is selected (special internal handling)
    final currentType = _mapToFilterBarType(selectedType);
    final isExpenseSelected = currentType == _FilterBarType.expense;
    final isIncomeSelected = currentType == _FilterBarType.income;
    final isAllSelected = !isExpenseSelected && !isIncomeSelected;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type filter tabs in a styled container
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildFilterTab(
                  context: context,
                  label: 'All',
                  icon: Icons.all_inclusive,
                  isSelected: isAllSelected,
                  onSelected: onClearFilters,
                ),
                _buildFilterTab(
                  context: context,
                  label: 'Expenses',
                  icon: Icons.arrow_downward,
                  isSelected: isExpenseSelected,
                  color: AppColors.expense,
                  onSelected: () => onTypeChanged(TransactionType.expense),
                ),
                _buildFilterTab(
                  context: context,
                  label: 'Income',
                  icon: Icons.arrow_upward,
                  isSelected: isIncomeSelected,
                  color: AppColors.income,
                  onSelected: () => onTypeChanged(TransactionType.income),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Additional filters
          Text(
            'Additional Filters',
            style: Theme.of(context).textTheme.titleSmall,
          ),

          const SizedBox(height: 8),

          // Filter buttons
          Row(
            children: [
              // Category filter
              Expanded(
                child: _buildFilterButton(
                  context: context,
                  label: 'Category',
                  icon: Icons.category,
                  onPressed: () => _showCategoryPicker(context),
                ),
              ),
              const SizedBox(width: 12),
              // Date range filter
              Expanded(
                child: _buildFilterButton(
                  context: context,
                  label: 'Date Range',
                  icon: Icons.calendar_today,
                  onPressed: () => _showDateRangePicker(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onSelected,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? colorScheme.onPrimary
                    : color ?? colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Select Category',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Categories list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final color =
                          AppColors.categoryColors[category.toLowerCase()] ??
                              AppColors.categoryColors['other']!;

                      IconData categoryIcon;
                      switch (index) {
                        case 0:
                          categoryIcon = Icons.restaurant;
                        case 1:
                          categoryIcon = Icons.directions_car;
                        case 2:
                          categoryIcon = Icons.shopping_cart;
                        case 3:
                          categoryIcon = Icons.receipt;
                        case 4:
                          categoryIcon = Icons.movie;
                        case 5:
                          categoryIcon = Icons.medical_services;
                        default:
                          categoryIcon = Icons.category;
                      }

                      return InkWell(
                        onTap: () {
                          onCategorySelected(category);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  categoryIcon,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                category,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: Theme.of(context).colorScheme.primary,
              headerForegroundColor: Theme.of(context).colorScheme.onPrimary,
              rangePickerBackgroundColor: Theme.of(context).colorScheme.surface,
              rangePickerSurfaceTintColor:
                  Theme.of(context).colorScheme.surfaceTint,
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
