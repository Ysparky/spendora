import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/statistics/presentation/controllers/statistics_controller.dart';

/// Widget that displays a pie chart for category spending
class PieChartSection extends StatelessWidget {
  /// Constructor
  const PieChartSection({
    required this.categories,
    this.title = 'Spending by Category',
    super.key,
  });

  /// The categories to display
  final List<CategorySpending> categories;

  /// Title of the section
  final String title;

  @override
  Widget build(BuildContext context) {
    final totalSpending = categories.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );

    // If there's no spending data, show empty state
    if (totalSpending == 0 || categories.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        // Pie chart
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              // Pie chart
              Padding(
                padding: const EdgeInsets.all(16),
                child: PieChart(
                  PieChartData(
                    sections: _createSections(),
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (_, __) {},
                      enabled: true,
                    ),
                  ),
                ),
              ),
              // Total in center
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalSpending.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Legend
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: categories.map((category) {
              return _buildLegendItem(
                context,
                category,
                totalSpending,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Create pie chart sections
  List<PieChartSectionData> _createSections() {
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final color = _getCategoryColor(category.category);

      sections.add(
        PieChartSectionData(
          color: color,
          value: category.amount,
          title: '',
          radius: 45,
          titleStyle: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return sections;
  }

  /// Build a legend item for a category
  Widget _buildLegendItem(
    BuildContext context,
    CategorySpending category,
    double totalSpending,
  ) {
    final percentage = (category.amount / totalSpending) * 100;
    final color = _getCategoryColor(category.category);
    final displayName = _getCategoryDisplayName(category.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Row(
                children: [
                  Text(
                    '\$${category.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${percentage.toStringAsFixed(1)}%)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get color for a category
  Color _getCategoryColor(String category) {
    return AppColors.categoryColors[category.toLowerCase()] ??
        AppColors.categoryColors['other']!;
  }

  /// Get display name for a category
  String _getCategoryDisplayName(String category) {
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
      case 'other':
        return 'Other';
      default:
        // Capitalize first letter
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }

  /// Build empty state when there's no spending data
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  size: 60,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No spending data for this period',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
