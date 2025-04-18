import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Repository interface for transaction operations
abstract class TransactionRepository {
  /// Stream of all transactions for a user
  Stream<List<TransactionModel>> getTransactions(String userId);

  /// Get a single transaction by ID
  Future<TransactionModel?> getTransactionById(
    String userId,
    String transactionId,
  );

  /// Add a new transaction
  Future<void> addTransaction(TransactionModel transaction);

  /// Update an existing transaction
  Future<void> updateTransaction(TransactionModel transaction);

  /// Delete a transaction
  Future<void> deleteTransaction(String userId, String transactionId);

  /// Get transactions by category
  Stream<List<TransactionModel>> getTransactionsByCategory(
    String userId,
    String category,
  );

  /// Get transactions by date range
  Stream<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get transactions by type (income/expense)
  Stream<List<TransactionModel>> getTransactionsByType(
    String userId,
    TransactionType type,
  );
}
