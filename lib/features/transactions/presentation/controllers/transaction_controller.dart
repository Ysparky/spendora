import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/transactions/data/providers/transaction_providers.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

part 'transaction_controller.g.dart';

/// Controller for managing transaction operations
@riverpod
class TransactionController extends _$TransactionController {
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

  /// Stream of all user transactions
  Stream<List<TransactionModel>> getTransactions() {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.getTransactions(_userId);
  }

  /// Stream of transactions filtered by category
  Stream<List<TransactionModel>> getTransactionsByCategory(String category) {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.getTransactionsByCategory(_userId, category);
  }

  /// Stream of transactions filtered by date range
  Stream<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.getTransactionsByDateRange(_userId, startDate, endDate);
  }

  /// Stream of transactions filtered by type (income/expense)
  Stream<List<TransactionModel>> getTransactionsByType(TransactionType type) {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.getTransactionsByType(_userId, type);
  }

  /// Add a new transaction
  Future<void> addTransaction({
    required String title,
    required double amount,
    required String category,
    required TransactionType type,
    String? description,
    DateTime? date,
    bool isRecurring = false,
    String? recurringFrequency,
  }) async {
    state = const AsyncLoading();

    try {
      final transaction = TransactionModel.create(
        userId: _userId,
        title: title,
        amount: amount,
        category: category,
        type: type,
        description: description,
        date: date,
        isRecurring: isRecurring,
        recurringFrequency: recurringFrequency,
      );

      final repository = ref.read(transactionRepositoryProvider);
      await repository.addTransaction(transaction);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(
        'Failed to add transaction: $error',
        stackTrace,
      );
      rethrow;
    }
  }

  /// Update an existing transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    state = const AsyncLoading();

    try {
      // Ensure the user can only update their own transactions
      if (transaction.userId != _userId) {
        throw Exception('You can only update your own transactions');
      }

      final repository = ref.read(transactionRepositoryProvider);
      await repository.updateTransaction(transaction);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(
        'Failed to update transaction: $error',
        stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteTransaction(_userId, transactionId);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(
        'Failed to delete transaction: $error',
        stackTrace,
      );
      rethrow;
    }
  }
}
