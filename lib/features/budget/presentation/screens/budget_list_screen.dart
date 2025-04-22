import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/budget/domain/models/budget_model.dart';
import 'package:spendora/features/budget/presentation/controllers/budget_controller.dart';
import 'package:spendora/features/budget/presentation/widgets/budget_form.dart';
import 'package:spendora/features/budget/presentation/widgets/budget_progress_card.dart';

/// Screen that displays a list of budgets
class BudgetListScreen extends ConsumerStatefulWidget {
  /// Whether to show the add budget form immediately
  final bool showAddBudgetForm;

  /// Constructor
  const BudgetListScreen({
    super.key,
    this.showAddBudgetForm = false,
  });

  @override
  ConsumerState<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends ConsumerState<BudgetListScreen> {
  bool _showOnlyActive = true;
  String? _selectedCategory;
  final _categories = [
    'food',
    'transport',
    'shopping',
    'bills',
    'entertainment',
    'health',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    // Show add budget form on init if requested
    if (widget.showAddBudgetForm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddBudgetBottomSheet(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetController = ref.watch(budgetControllerProvider);
    final budgetsStream =
        ref.watch(budgetControllerProvider.notifier).getBudgets();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<BudgetModel>>(
        stream: budgetsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading budgets: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No budgets found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create a budget to track your spending',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _showAddBudgetBottomSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Budget'),
                  ),
                ],
              ),
            );
          }

          // Filter budgets based on active status and category
          final filteredBudgets = snapshot.data!.where((budget) {
            final activeFilter = _showOnlyActive ? budget.isActive : true;
            final categoryFilter = _selectedCategory == null
                ? true
                : budget.category == _selectedCategory;
            return activeFilter && categoryFilter;
          }).toList();

          // Sort by creation date (newest first)
          filteredBudgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (filteredBudgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  const Text('No budgets match your filters'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showOnlyActive = true;
                        _selectedCategory = null;
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // This will trigger a refresh of the stream
              setState(() {});
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBudgets.length,
              itemBuilder: (context, index) {
                final budget = filteredBudgets[index];
                return BudgetProgressCard(
                  budget: budget,
                  onTap: () => _showBudgetOptions(context, budget),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Budgets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),

                  // Show active/all budgets
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Active'),
                        icon: Icon(Icons.visibility),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('All'),
                        icon: Icon(Icons.list),
                      ),
                    ],
                    selected: {_showOnlyActive},
                    onSelectionChanged: (selection) {
                      setModalState(() {
                        _showOnlyActive = selection.first;
                      });
                      setState(() {
                        _showOnlyActive = selection.first;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Category filter
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Add "All" option
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              _selectedCategory = null;
                            });
                            setState(() {
                              _selectedCategory = null;
                            });
                          }
                        },
                      ),
                      // Add category options
                      ..._categories.map((category) {
                        return FilterChip(
                          label: Text(_getCategoryDisplayName(category)),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                _selectedCategory = category;
                              });
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddBudgetBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Budget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final budgetState = ref.watch(budgetControllerProvider);
                    final isLoading = budgetState is AsyncLoading;

                    return BudgetForm(
                      isLoading: isLoading,
                      onSubmit: ({
                        required String category,
                        required double amount,
                        required BudgetPeriod period,
                        DateTime? startDate,
                        DateTime? endDate,
                        required bool isActive,
                        String? notes,
                      }) {
                        ref
                            .read(budgetControllerProvider.notifier)
                            .addBudget(
                              category: category,
                              amount: amount,
                              period: period,
                              startDate: startDate,
                              endDate: endDate,
                              isActive: isActive,
                              notes: notes,
                            )
                            .then((_) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            _showSuccessSnackBar(
                                context, 'Budget created successfully');
                          }
                        }).catchError((e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            _showErrorSnackBar(
                                context, 'Failed to create budget: $e');
                          }
                          return null;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditBudgetBottomSheet(BuildContext context, BudgetModel budget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Budget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final budgetState = ref.watch(budgetControllerProvider);
                    final isLoading = budgetState is AsyncLoading;

                    return BudgetForm(
                      initialBudget: budget,
                      isLoading: isLoading,
                      onSubmit: ({
                        required String category,
                        required double amount,
                        required BudgetPeriod period,
                        DateTime? startDate,
                        DateTime? endDate,
                        required bool isActive,
                        String? notes,
                      }) {
                        final updatedBudget = budget.copyWith(
                          category: category,
                          amount: amount,
                          period: period,
                          startDate: startDate,
                          endDate: endDate,
                          isActive: isActive,
                          notes: notes,
                        );

                        ref
                            .read(budgetControllerProvider.notifier)
                            .updateBudget(updatedBudget)
                            .then((_) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            _showSuccessSnackBar(
                                context, 'Budget updated successfully');
                          }
                        }).catchError((e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            _showErrorSnackBar(
                                context, 'Failed to update budget: $e');
                          }
                          return null;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBudgetOptions(BuildContext context, BudgetModel budget) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final currencyFormat = NumberFormat.currency(symbol: r'$');
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Budget details header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.categoryColors[budget.category] ??
                          AppColors.categoryColors['other']!,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(budget.category),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryDisplayName(budget.category),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${budget.period.displayName} Budget',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormat.format(budget.amount),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),

              // Budget options
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Budget'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditBudgetBottomSheet(context, budget);
                },
              ),

              if (budget.isActive)
                ListTile(
                  leading: const Icon(Icons.visibility_off),
                  title: const Text('Deactivate Budget'),
                  onTap: () async {
                    Navigator.pop(context);
                    _confirmDeactivateBudget(context, budget);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text('Activate Budget'),
                  onTap: () async {
                    Navigator.pop(context);
                    _activateBudget(context, budget);
                  },
                ),

              ListTile(
                leading: Icon(Icons.delete, color: colorScheme.error),
                title: Text('Delete Budget',
                    style: TextStyle(color: colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteBudget(context, budget);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeactivateBudget(BuildContext context, BudgetModel budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Budget'),
        content: const Text(
            'Are you sure you want to deactivate this budget? It will no longer track your spending.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final updatedBudget = budget.copyWith(isActive: false);
                await ref
                    .read(budgetControllerProvider.notifier)
                    .updateBudget(updatedBudget);
                if (context.mounted) {
                  _showSuccessSnackBar(context, 'Budget deactivated');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorSnackBar(
                      context, 'Failed to deactivate budget: $e');
                }
              }
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _activateBudget(BuildContext context, BudgetModel budget) async {
    try {
      final updatedBudget = budget.copyWith(isActive: true);
      await ref
          .read(budgetControllerProvider.notifier)
          .updateBudget(updatedBudget);
      if (context.mounted) {
        _showSuccessSnackBar(context, 'Budget activated');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to activate budget: $e');
      }
    }
  }

  void _confirmDeleteBudget(BuildContext context, BudgetModel budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text(
            'Are you sure you want to delete this budget? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(budgetControllerProvider.notifier)
                    .deleteBudget(budget.id);
                if (context.mounted) {
                  _showSuccessSnackBar(context, 'Budget deleted successfully');
                }
              } catch (e) {
                if (context.mounted) {
                  _showErrorSnackBar(context, 'Failed to delete budget: $e');
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'Food & Drinks';
      case 'transport':
        return 'Transportation';
      case 'shopping':
        return 'Shopping';
      case 'bills':
        return 'Bills & Utilities';
      case 'entertainment':
        return 'Entertainment';
      case 'health':
        return 'Healthcare';
      default:
        // Capitalize first letter
        return category.substring(0, 1).toUpperCase() + category.substring(1);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'bills':
        return Icons.receipt;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }
}
