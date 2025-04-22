import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';
import 'package:spendora/features/transactions/presentation/controllers/transaction_controller.dart';
import 'package:spendora/features/transactions/presentation/widgets/transaction_filter_bar.dart';
import 'package:spendora/features/transactions/presentation/widgets/transaction_list_item.dart';

/// Enum for filter types to better handle "All" transactions
enum FilterType {
  expense,
  income,
  all,
}

/// Screen that displays a list of transactions
class TransactionListScreen extends ConsumerStatefulWidget {
  /// Constructor
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen>
    with SingleTickerProviderStateMixin {
  FilterType _selectedFilterType = FilterType.all; // Default to All
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showFilterOptions = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  late AnimationController _animationController;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _filterAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  void _toggleFilterOptions() {
    setState(() {
      _showFilterOptions = !_showFilterOptions;
      if (_showFilterOptions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Stream<List<TransactionModel>> _getFilteredTransactions() {
    final controller = ref.read(transactionControllerProvider.notifier);

    // Apply filters based on selected criteria
    if (_selectedCategory != null) {
      if (_selectedFilterType == FilterType.income) {
        // Filter by category AND income type
        return controller.getTransactionsByCategory(_selectedCategory!).map(
              (transactions) => transactions
                  .where((tx) => tx.type == TransactionType.income)
                  .toList(),
            );
      } else if (_selectedFilterType == FilterType.expense) {
        // Filter by category AND expense type
        return controller.getTransactionsByCategory(_selectedCategory!).map(
              (transactions) => transactions
                  .where((tx) => tx.type == TransactionType.expense)
                  .toList(),
            );
      } else {
        // Filter just by category (both income and expense)
        return controller.getTransactionsByCategory(_selectedCategory!);
      }
    } else if (_startDate != null && _endDate != null) {
      if (_selectedFilterType == FilterType.income) {
        // Filter by date range AND income type
        return controller
            .getTransactionsByDateRange(_startDate!, _endDate!)
            .map(
              (transactions) => transactions
                  .where((tx) => tx.type == TransactionType.income)
                  .toList(),
            );
      } else if (_selectedFilterType == FilterType.expense) {
        // Filter by date range AND expense type
        return controller
            .getTransactionsByDateRange(_startDate!, _endDate!)
            .map(
              (transactions) => transactions
                  .where((tx) => tx.type == TransactionType.expense)
                  .toList(),
            );
      } else {
        // Filter just by date range (both income and expense)
        return controller.getTransactionsByDateRange(_startDate!, _endDate!);
      }
    } else if (_selectedFilterType == FilterType.income) {
      // Filter just by income type
      return controller.getTransactionsByType(TransactionType.income);
    } else if (_selectedFilterType == FilterType.expense) {
      // Filter just by expense type
      return controller.getTransactionsByType(TransactionType.expense);
    } else {
      // Return all transactions (both income and expense)
      return controller.getTransactions();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _startDate = null;
      _endDate = null;
      _selectedFilterType = FilterType.all; // Reset to All
    });
  }

  String _getActiveFiltersText() {
    final activeFilters = <String>[];

    // Add transaction type filter
    if (_selectedFilterType == FilterType.income) {
      activeFilters.add('Income');
    } else if (_selectedFilterType == FilterType.expense) {
      activeFilters.add('Expenses');
    } else {
      activeFilters.add('All');
    }

    // Add category filter if present
    if (_selectedCategory != null) {
      activeFilters.add(_selectedCategory!);
    }

    // Add date range filter if present
    if (_startDate != null && _endDate != null) {
      final formatter = DateFormat('MMM d');
      activeFilters.add(
        '${formatter.format(_startDate!)} - ${formatter.format(_endDate!)}',
      );
    }

    return activeFilters.join(' • ');
  }

  void _showAddTransactionModal() {
    context.push('/transactions/add');
  }

  // void _showDeleteConfirmation(
  //     BuildContext context, TransactionModel transaction) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Transaction'),
  //       content: Text(
  //         'Are you sure you want to delete "${transaction.title}"?',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Cancel'),
  //         ),
  //         FilledButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             _deleteTransaction(transaction.id);
  //           },
  //           style: FilledButton.styleFrom(
  //             backgroundColor: Theme.of(context).colorScheme.error,
  //           ),
  //           child: const Text('Delete'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _deleteTransaction(String transactionId) async {
    try {
      await ref
          .read(transactionControllerProvider.notifier)
          .deleteTransaction(transactionId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction deleted'),
          behavior: SnackBarBehavior.floating,
          width: 280,
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
          ),
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          width: 280,
        ),
      );
    }
  }

  void _editTransaction(TransactionModel transaction) {
    context.push('/transactions/edit/${transaction.id}');
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionControllerProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _filterAnimation,
              color: _showFilterOptions ? colorScheme.primary : null,
            ),
            tooltip: _showFilterOptions ? 'Hide filters' : 'Show filters',
            onPressed: _toggleFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getActiveFiltersText(),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_selectedCategory != null ||
                    _startDate != null ||
                    _selectedFilterType != FilterType.all)
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: colorScheme.error,
                    ),
                    label: Text(
                      'Clear',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
              ],
            ),
          ),

          // Animated filter bar
          SizeTransition(
            sizeFactor: _filterAnimation,
            child: TransactionFilterBar(
              selectedType:
                  _mapFilterTypeToTransactionType(_selectedFilterType),
              onTypeChanged: (type) {
                setState(() {
                  // Convert TransactionType to our FilterType
                  if (type == TransactionType.expense) {
                    _selectedFilterType = FilterType.expense;
                  } else if (type == TransactionType.income) {
                    _selectedFilterType = FilterType.income;
                  } else {
                    _selectedFilterType = FilterType.all;
                  }
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
              onClearFilters: _clearFilters,
            ),
          ),

          // Transactions list
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: _getFilteredTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading transactions',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try changing your filters or add a new transaction',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Transaction'),
                          onPressed: _showAddTransactionModal,
                        ),
                      ],
                    ),
                  );
                } else {
                  // Group transactions by date
                  final transactionsByDate = <String, List<TransactionModel>>{};
                  final dateFormatter = DateFormat('MMMM d, yyyy');
                  final todayDate = DateTime.now();
                  final today =
                      DateTime(todayDate.year, todayDate.month, todayDate.day);
                  final yesterday = today.subtract(const Duration(days: 1));

                  for (final transaction in snapshot.data!) {
                    final transactionDate = DateTime(
                      transaction.date.year,
                      transaction.date.month,
                      transaction.date.day,
                    );

                    String dateStr;
                    if (transactionDate == today) {
                      dateStr = 'Today';
                    } else if (transactionDate == yesterday) {
                      dateStr = 'Yesterday';
                    } else {
                      dateStr = dateFormatter.format(transaction.date);
                    }

                    transactionsByDate.putIfAbsent(dateStr, () => []);
                    transactionsByDate[dateStr]!.add(transaction);
                  }

                  // Calculate daily totals
                  final dailyTotals = <String, Map<String, double>>{};
                  for (final dateEntry in transactionsByDate.entries) {
                    double income = 0;
                    double expense = 0;

                    for (final transaction in dateEntry.value) {
                      if (transaction.type == TransactionType.income) {
                        income += transaction.amount;
                      } else {
                        expense += transaction.amount;
                      }
                    }

                    dailyTotals[dateEntry.key] = {
                      'income': income,
                      'expense': expense,
                      'balance': income - expense,
                    };
                  }

                  return transactionState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: transactionsByDate.keys.length,
                          itemBuilder: (context, index) {
                            final dateStr =
                                transactionsByDate.keys.elementAt(index);
                            final transactions = transactionsByDate[dateStr]!;
                            final totals = dailyTotals[dateStr]!;
                            final currencyFormat =
                                NumberFormat.currency(symbol: r'$');

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                                  color: colorScheme.surface,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dateStr,
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            currencyFormat
                                                .format(totals['balance']),
                                            style:
                                                textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: totals['balance']! >= 0
                                                  ? AppColors.income
                                                  : AppColors.expense,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (totals['income']! > 0 ||
                                          totals['expense']! > 0)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            children: [
                                              if (totals['income']! > 0)
                                                Text(
                                                  'Income: ${currencyFormat.format(totals['income'])}',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppColors.income,
                                                  ),
                                                ),
                                              if (totals['income']! > 0 &&
                                                  totals['expense']! > 0)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    '•',
                                                    style: textTheme.bodySmall,
                                                  ),
                                                ),
                                              if (totals['expense']! > 0)
                                                Text(
                                                  'Expense: ${currencyFormat.format(totals['expense'])}',
                                                  style: textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: AppColors.expense,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                ...transactions.map(
                                  (transaction) => Dismissible(
                                    key: ValueKey(transaction.id),
                                    background: Container(
                                      color: colorScheme.primary,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Icon(
                                        Icons.edit,
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      color: colorScheme.error,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.delete,
                                        color: colorScheme.onError,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        // Delete action
                                        final result = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Delete Transaction',
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete "${transaction.title}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                style: FilledButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                ),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return result ?? false;
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        // Edit action
                                        _editTransaction(transaction);
                                        return false; // Don't actually dismiss the item
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        _deleteTransaction(transaction.id);
                                      }
                                    },
                                    child: TransactionListItem(
                                      transaction: transaction,
                                      onTap: () {
                                        context.push(
                                          '/transactions/details/${transaction.id}',
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (index < transactionsByDate.keys.length - 1)
                                  const SizedBox(height: 16)
                                else
                                  const SizedBox(
                                    height: 80,
                                  ), // More space at the bottom
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
      floatingActionButton: AnimatedOpacity(
        opacity: _isScrolled ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: _showAddTransactionModal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Helper method to map our FilterType to TransactionType for the filter bar
  TransactionType _mapFilterTypeToTransactionType(FilterType filterType) {
    switch (filterType) {
      case FilterType.expense:
        return TransactionType.expense;
      case FilterType.income:
        return TransactionType.income;
      case FilterType.all:
        // Return any value since the filter bar handles "All" specially
        return TransactionType.expense;
    }
  }
}
