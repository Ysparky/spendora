import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

/// Budget model representing a user's budget for a specific category
@freezed
abstract class BudgetModel with _$BudgetModel {
  /// Private constructor
  const BudgetModel._();

  /// Default constructor
  @JsonSerializable(explicitToJson: true)
  const factory BudgetModel({
    required String id,
    required String userId,
    required String category,
    required double amount,
    required BudgetPeriod period,
    DateTime? startDate,
    DateTime? endDate,
    @Default(false) bool isActive,
    @Default(0.0) double spent,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BudgetModel;

  /// Create a new budget with default values
  factory BudgetModel.create({
    required String userId,
    required String category,
    required double amount,
    required BudgetPeriod period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? notes,
  }) {
    final now = DateTime.now();
    return BudgetModel(
      id: const Uuid().v4(),
      userId: userId,
      category: category,
      amount: amount,
      period: period,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive ?? true,
      spent: 0.0,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Calculate the percentage spent of the budget
  double get percentSpent => amount > 0 ? (spent / amount) * 100 : 0;

  /// Check if the budget is over the limit
  bool get isOverBudget => spent > amount;

  /// Get the remaining amount in the budget
  double get remaining => amount - spent;

  /// Get the percentage remaining in the budget
  double get percentRemaining => 100 - percentSpent;

  /// Create from JSON
  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);
}

/// Budget period enum
enum BudgetPeriod {
  /// Daily budget
  daily,

  /// Weekly budget
  weekly,

  /// Monthly budget
  monthly,

  /// Yearly budget
  yearly,
}

/// Extension for BudgetPeriod to get display name
extension BudgetPeriodExtension on BudgetPeriod {
  /// Get display name for budget period
  String get displayName {
    switch (this) {
      case BudgetPeriod.daily:
        return 'Daily';
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }

  /// Get the number of days in the period
  int get days {
    switch (this) {
      case BudgetPeriod.daily:
        return 1;
      case BudgetPeriod.weekly:
        return 7;
      case BudgetPeriod.monthly:
        return 30; // Approximation
      case BudgetPeriod.yearly:
        return 365; // Approximation
    }
  }
}
