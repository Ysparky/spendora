import 'package:flutter/material.dart';
import 'package:spendora/features/dashboard/presentation/widgets/category_spending_card.dart';

/// Widget for displaying the category spending list
class CategorySpendingList extends StatelessWidget {
  const CategorySpendingList({
    required this.categorySpending,
    super.key,
  });

  final Map<String, double> categorySpending;

  @override
  Widget build(BuildContext context) {
    // Calculate total spending
    final totalSpending =
        categorySpending.values.fold<double>(0, (sum, amount) => sum + amount);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categorySpending.length,
      itemBuilder: (context, index) {
        final category = categorySpending.keys.elementAt(index);
        final amount = categorySpending[category]!;
        final percentage = (amount / totalSpending) * 100;

        return CategorySpendingCard(
          category: category,
          amount: amount,
          percentage: percentage,
        );
      },
    );
  }
}
