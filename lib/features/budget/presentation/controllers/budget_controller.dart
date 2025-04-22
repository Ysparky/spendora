import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/budget/data/providers/budget_providers.dart';
import 'package:spendora/features/budget/domain/models/budget_model.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

part 'budget_controller.g.dart';

/// Controller for budget operations
@riverpod
class BudgetController extends _$BudgetController {
  @override
  AsyncValue<void> build() {
    // Initial state is void
    return const AsyncData(null);
  }

  /// Get the current user ID
  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to perform this action');
    }
    return user.uid;
  }

  /// Stream of all user budgets
  Stream<List<BudgetModel>> getBudgets() {
    final repository = ref.read(budgetRepositoryProvider);
    return repository.getBudgets(_userId);
  }

  /// Stream of active budgets
  Stream<List<BudgetModel>> getActiveBudgets() {
    final repository = ref.read(budgetRepositoryProvider);
    return repository.getActiveBudgets(_userId);
  }

  /// Stream of budgets for a specific category
  Stream<List<BudgetModel>> getBudgetsByCategory(String category) {
    final repository = ref.read(budgetRepositoryProvider);
    return repository.getBudgetsByCategory(_userId, category);
  }

  /// Get a specific budget by ID
  Future<BudgetModel?> getBudgetById(String budgetId) {
    final repository = ref.read(budgetRepositoryProvider);
    return repository.getBudgetById(_userId, budgetId);
  }

  /// Add a new budget
  Future<void> addBudget({
    required String category,
    required double amount,
    required BudgetPeriod period,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? notes,
  }) async {
    state = const AsyncLoading();

    try {
      final budget = BudgetModel.create(
        userId: _userId,
        category: category,
        amount: amount,
        period: period,
        startDate: startDate,
        endDate: endDate,
        isActive: isActive,
        notes: notes,
      );

      final repository = ref.read(budgetRepositoryProvider);
      await repository.addBudget(budget);
      state = const AsyncData(null);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(
        'Failed to add budget: $error',
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update an existing budget
  Future<void> updateBudget(BudgetModel budget) async {
    state = const AsyncLoading();

    try {
      // Ensure the user can only update their own budgets
      if (budget.userId != _userId) {
        throw Exception('You can only update your own budgets');
      }

      final repository = ref.read(budgetRepositoryProvider);
      await repository.updateBudget(budget);
      state = const AsyncData(null);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(
        'Failed to update budget: $error',
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.deleteBudget(_userId, budgetId);
      state = const AsyncData(null);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(
        'Failed to delete budget: $error',
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update budget spent amount when a transaction is added or updated
  Future<void> processTransaction(
    TransactionModel transaction, {
    bool isDeleting = false,
  }) async {
    try {
      // Only process expense transactions
      if (transaction.type != TransactionType.expense) return;

      // Find active budgets for this category
      final repository = ref.read(budgetRepositoryProvider);
      final budgets = await repository
          .getBudgetsByCategory(_userId, transaction.category)
          .first;

      if (budgets.isEmpty) return;

      // Get the current date to filter budgets by date range
      final now = DateTime.now();

      // Update each matching budget
      for (final budget in budgets) {
        // Skip if budget is inactive
        if (!budget.isActive) continue;

        // Skip if transaction date is outside budget date range
        if (budget.startDate != null &&
            transaction.date.isBefore(budget.startDate!)) {
          continue;
        }
        if (budget.endDate != null &&
            transaction.date.isAfter(budget.endDate!)) {
          continue;
        }

        // Calculate amount to update
        // If deleting, subtract the transaction amount
        // Otherwise, add the transaction amount
        final amountToUpdate =
            isDeleting ? -transaction.amount : transaction.amount;

        await repository.updateBudgetSpent(
          _userId,
          budget.id,
          amountToUpdate,
        );
      }
    } on Exception catch (error, stackTrace) {
      state = AsyncError(
        'Failed to update budget spent: $error',
        stackTrace,
      );
      rethrow;
    }
  }
}
