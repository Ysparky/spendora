import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:spendora/features/transactions/domain/models/transaction_model.dart';
import 'package:spendora/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:spendora/features/transactions/presentation/widgets/transaction_filter_bar.dart';
import 'package:spendora/features/transactions/presentation/widgets/transaction_list_item.dart';

/// Screen that displays a list of transactions
class TransactionListScreen extends ConsumerStatefulWidget {
  /// Constructor
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  Stream<List<TransactionModel>> _getFilteredTransactions() {
    final controller = ref.read(transactionControllerProvider.notifier);

    // Apply filters based on selected criteria
    if (_selectedCategory != null) {
      return controller.getTransactionsByCategory(_selectedCategory!);
    } else if (_startDate != null && _endDate != null) {
      return controller.getTransactionsByDateRange(_startDate!, _endDate!);
    } else if (_selectedType != TransactionType.expense) {
      return controller.getTransactionsByType(_selectedType);
    } else {
      return controller.getTransactions();
    }
  }

  void _showAddTransactionModal() {
    context.push('/transactions/add');
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement advanced filtering
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TransactionFilterBar(
            selectedType: _selectedType,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
                // Clear other filters when type changes
                _selectedCategory = null;
                _startDate = null;
                _endDate = null;
              });
            },
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
                // Clear date range when category selected
                _startDate = null;
                _endDate = null;
              });
            },
            onDateRangeSelected: (dateRange) {
              setState(() {
                _startDate = dateRange.start;
                _endDate = dateRange.end;
                // Clear category when date range selected
                _selectedCategory = null;
              });
            },
            onClearFilters: () {
              setState(() {
                _selectedCategory = null;
                _startDate = null;
                _endDate = null;
                _selectedType = TransactionType.expense;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: _getFilteredTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading transactions: ${snapshot.error}',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Add your first transaction'),
                          onPressed: _showAddTransactionModal,
                        ),
                      ],
                    ),
                  );
                } else {
                  // Group transactions by date
                  final transactionsByDate = <String, List<TransactionModel>>{};
                  final formatter = DateFormat('MMMM d, yyyy');

                  for (final transaction in snapshot.data!) {
                    final dateStr = formatter.format(transaction.date);
                    transactionsByDate.putIfAbsent(dateStr, () => []);
                    transactionsByDate[dateStr]!.add(transaction);
                  }

                  return transactionState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: transactionsByDate.keys.length,
                          itemBuilder: (context, index) {
                            final dateStr =
                                transactionsByDate.keys.elementAt(index);
                            final transactions = transactionsByDate[dateStr]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    dateStr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                ...transactions.map(
                                  (transaction) => TransactionListItem(
                                    transaction: transaction,
                                    onTap: () {
                                      context.push(
                                        '/transactions/details/${transaction.id}',
                                      );
                                    },
                                  ),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
