import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/transactions/data/repositories/firestore_transaction_repository.dart';
import 'package:spendora/features/transactions/domain/repositories/transaction_repository.dart';

part 'transaction_providers.g.dart';

/// Provider for transaction repository
@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) {
  return FirestoreTransactionRepository();
}
