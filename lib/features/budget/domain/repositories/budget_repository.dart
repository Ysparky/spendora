import 'package:spendora/features/budget/domain/models/budget_model.dart';

/// Repository interface for budget operations
abstract class BudgetRepository {
  /// Get a stream of all budgets for a user
  Stream<List<BudgetModel>> getBudgets(String userId);

  /// Get a specific budget by ID
  Future<BudgetModel?> getBudgetById(String userId, String budgetId);

  /// Get budgets for a specific category
  Stream<List<BudgetModel>> getBudgetsByCategory(
      String userId, String category);

  /// Get active budgets
  Stream<List<BudgetModel>> getActiveBudgets(String userId);

  /// Add a new budget
  Future<void> addBudget(BudgetModel budget);

  /// Update an existing budget
  Future<void> updateBudget(BudgetModel budget);

  /// Delete a budget
  Future<void> deleteBudget(String userId, String budgetId);

  /// Update the spent amount for a budget
  Future<void> updateBudgetSpent(String userId, String budgetId, double amount);
}
