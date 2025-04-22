import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendora/features/budget/domain/models/budget_model.dart';
import 'package:spendora/features/budget/domain/repositories/budget_repository.dart';

/// Implementation of [BudgetRepository] using Firestore
class FirestoreBudgetRepository implements BudgetRepository {
  /// Constructor
  FirestoreBudgetRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Collection reference for budgets
  CollectionReference<Map<String, dynamic>> get _budgetsCollection =>
      _firestore.collection('budgets');

  @override
  Stream<List<BudgetModel>> getBudgets(String userId) {
    return _budgetsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BudgetModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<BudgetModel?> getBudgetById(String userId, String budgetId) async {
    final doc = await _budgetsCollection.doc(budgetId).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    // Verify this budget belongs to the user
    if (data['userId'] != userId) return null;

    return BudgetModel.fromJson(data);
  }

  @override
  Stream<List<BudgetModel>> getBudgetsByCategory(
    String userId,
    String category,
  ) {
    return _budgetsCollection
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BudgetModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<BudgetModel>> getActiveBudgets(String userId) {
    return _budgetsCollection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BudgetModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> addBudget(BudgetModel budget) async {
    await _budgetsCollection.doc(budget.id).set(budget.toJson());
  }

  @override
  Future<void> updateBudget(BudgetModel budget) async {
    // First verify the budget exists and belongs to the user
    final existingBudget = await getBudgetById(budget.userId, budget.id);
    if (existingBudget == null) {
      throw Exception('Budget not found or does not belong to user');
    }

    // Update with new date
    final updatedBudget = budget.copyWith(updatedAt: DateTime.now());
    await _budgetsCollection.doc(budget.id).update(updatedBudget.toJson());
  }

  @override
  Future<void> deleteBudget(String userId, String budgetId) async {
    // First verify the budget exists and belongs to the user
    final existingBudget = await getBudgetById(userId, budgetId);
    if (existingBudget == null) {
      throw Exception('Budget not found or does not belong to user');
    }

    await _budgetsCollection.doc(budgetId).delete();
  }

  @override
  Future<void> updateBudgetSpent(
    String userId,
    String budgetId,
    double amount,
  ) async {
    // First verify the budget exists and belongs to the user
    final existingBudget = await getBudgetById(userId, budgetId);
    if (existingBudget == null) {
      throw Exception('Budget not found or does not belong to user');
    }

    // Update the spent amount
    final newSpent = existingBudget.spent + amount;
    final updatedBudget = existingBudget.copyWith(
      spent: newSpent,
      updatedAt: DateTime.now(),
    );

    await _budgetsCollection.doc(budgetId).update(updatedBudget.toJson());
  }
}
