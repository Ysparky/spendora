import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/budget/data/repositories/firestore_budget_repository.dart';
import 'package:spendora/features/budget/domain/repositories/budget_repository.dart';

/// Provider for the budget repository
final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => FirestoreBudgetRepository(),
);
