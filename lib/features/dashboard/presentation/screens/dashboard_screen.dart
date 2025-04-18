import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendora/features/auth/presentation/controllers/auth_controller.dart';
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

  // Mock total amounts
  final Map<String, Map<String, double>> _mockTotals = {
    'This Week': {
      'income': 340.00,
      'expense': 220.50,
    },
    'This Month': {
      'income': 1450.00,
      'expense': 980.75,
    },
    'This Year': {
      'income': 12450.00,
      'expense': 9876.50,
    },
  };

  // Mock recent transactions
  final List<Map<String, dynamic>> _mockRecentTransactions = [
    {
      'id': 'tx1',
      'title': 'Grocery Shopping',
      'amount': 65.43,
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'category': 'food',
      'type': TransactionType.expense,
    },
    {
      'id': 'tx2',
      'title': 'Salary Deposit',
      'amount': 1200.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'category': 'other',
      'type': TransactionType.income,
    },
    {
      'id': 'tx3',
      'title': 'Netflix Subscription',
      'amount': 15.99,
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'category': 'entertainment',
      'type': TransactionType.expense,
    },
    {
      'id': 'tx4',
      'title': 'Uber Ride',
      'amount': 22.50,
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'category': 'transport',
      'type': TransactionType.expense,
    },
  ];

  // Mock spending distribution
  final Map<String, double> _mockCategorySpending = {
    'food': 350.25,
    'transport': 125.50,
    'shopping': 204.75,
    'bills': 185.00,
    'entertainment': 96.25,
    'health': 19.00,
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // final currencyFormat = NumberFormat.currency(symbol: r'$');
    final selectedPeriod = _periods[_selectedPeriodIndex];

    // Calculate balance for selected period
    final income = _mockTotals[selectedPeriod]!['income'] ?? 0.0;
    final expense = _mockTotals[selectedPeriod]!['expense'] ?? 0.0;
    final balance = income - expense;

    // Get user display name for greeting
    final userName = user?.displayName?.split(' ').first ??
        user?.email?.split('@').first ??
        'User';

    return Scaffold(
      body: CustomScrollView(
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

                  // Balance card
                  BalanceCard(
                    period: selectedPeriod,
                    balance: balance,
                    income: income,
                    expense: expense,
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

                  SizedBox(
                    height: 180,
                    child: CategorySpendingList(
                      categorySpending: _mockCategorySpending,
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

                  ...(_mockRecentTransactions.isEmpty
                      ? [const EmptyTransactionMessage()]
                      : _mockRecentTransactions
                          .map(
                            (transaction) => TransactionItem(
                              transaction: transaction,
                              onTap: () => context.push('/transactions'),
                            ),
                          )
                          .toList()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
