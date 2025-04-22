import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendora/features/auth/presentation/controllers/auth_controller.dart';
import 'package:spendora/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:spendora/features/dashboard/presentation/widgets/index.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedPeriodIndex = 1; // Default to "This Month"
  final List<String> _periods = ['This Week', 'This Month', 'This Year'];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
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

  // Get the appropriate transaction stream based on selected period
  Stream<List<TransactionModel>> _getTransactionsForPeriod(int periodIndex) {
    final controller = ref.read(dashboardControllerProvider.notifier);

    switch (periodIndex) {
      case 0: // This Week
        return controller.getWeekTransactions();
      case 1: // This Month
        return controller.getMonthTransactions();
      case 2: // This Year
        return controller.getYearTransactions();
      default:
        return controller.getMonthTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // final currencyFormat = NumberFormat.currency(symbol: r'$');
    final selectedPeriod = _periods[_selectedPeriodIndex];

    // Get user display name for greeting
    final userName = user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'User';

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Hello, $userName'),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Profile',
                onPressed: () {
                  context.push('/profile');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Sign Out',
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Financial summary text
                  Text(
                    "Here's your financial summary",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Time period selector
                  PeriodSelector(
                    periods: _periods,
                    selectedIndex: _selectedPeriodIndex,
                    onPeriodChanged: (index) {
                      setState(() {
                        _selectedPeriodIndex = index;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Balance card with real data
                  StreamBuilder<List<TransactionModel>>(
                    stream: _getTransactionsForPeriod(_selectedPeriodIndex),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final transactions = snapshot.data ?? [];
                      final summary = ref
                          .read(dashboardControllerProvider.notifier)
                          .calculateFinancialSummary(transactions);

                      return BalanceCard(
                        period: selectedPeriod,
                        balance: summary['balance'] ?? 0,
                        income: summary['income'] ?? 0,
                        expense: summary['expense'] ?? 0,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Category spending
                  Text(
                    'Spending by Category',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Category spending list with real data
                  SizedBox(
                    height: 180,
                    child: StreamBuilder<List<TransactionModel>>(
                      stream: _getTransactionsForPeriod(_selectedPeriodIndex),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final transactions = snapshot.data ?? [];
                        final categorySpending = ref
                            .read(dashboardControllerProvider.notifier)
                            .calculateCategorySpending(transactions);

                        if (categorySpending.isEmpty) {
                          return Center(
                            child: Text(
                              'No spending data for this period',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }

                        return CategorySpendingList(
                          categorySpending: categorySpending,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/transactions');
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Recent transactions list with real data
                  StreamBuilder<List<TransactionModel>>(
                    stream: ref
                        .read(dashboardControllerProvider.notifier)
                        .getRecentTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !snapshot.hasData) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final transactions = snapshot.data ?? [];

                      if (transactions.isEmpty) {
                        return const EmptyTransactionMessage();
                      }

                      return Column(
                        children: transactions
                            .map(
                              (transaction) => TransactionItem(
                                transaction: transaction,
                                onTap: () => context.push(
                                    '/transactions/details/${transaction.id}'),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),

                  // Add bottom padding to ensure the last transaction item is visible
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isScrolled ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () => context.push('/transactions/add'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
