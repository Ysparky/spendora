import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';
import 'package:spendora/features/transactions/domain/repositories/transaction_repository.dart';

/// Firebase implementation of the [TransactionRepository]
class FirestoreTransactionRepository implements TransactionRepository {
  /// Constructor
  FirestoreTransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Collection name for transactions
  static const String _collection = 'transactions';

  /// Get a reference to the transactions collection
  CollectionReference<Map<String, dynamic>> get _transactionsRef =>
      _firestore.collection(_collection);

  @override
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Future<TransactionModel?> getTransactionById(
    String userId,
    String transactionId,
  ) async {
    final doc = await _transactionsRef.doc(transactionId).get();

    if (!doc.exists || doc.data()?['userId'] != userId) {
      return null;
    }

    return TransactionModel.fromJson(doc.data()!);
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionsRef.doc(transaction.id).set(transaction.toJson());
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionsRef.doc(transaction.id).update(transaction.toJson());
  }

  @override
  Future<void> deleteTransaction(String userId, String transactionId) async {
    final doc = await _transactionsRef.doc(transactionId).get();

    // Only delete if the transaction belongs to the user
    if (doc.exists && doc.data()?['userId'] == userId) {
      await _transactionsRef.doc(transactionId).delete();
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactionsByCategory(
    String userId,
    String category,
  ) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    final startTimestamp = Timestamp.fromDate(startDate);
    final endTimestamp = Timestamp.fromDate(endDate);

    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<TransactionModel>> getTransactionsByType(
    String userId,
    TransactionType type,
  ) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type.name)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    });
  }
}
