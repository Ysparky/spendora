import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/features/statistics/data/providers/statistics_providers.dart';
import 'package:spendora/features/statistics/domain/models/statistics_model.dart';
import 'package:spendora/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:spendora/features/statistics/presentation/widgets/pie_chart_section.dart';
import 'package:spendora/features/statistics/presentation/widgets/trend_chart_section.dart';

/// Screen for displaying financial statistics and visualizations
class StatisticsScreen extends ConsumerStatefulWidget {
  /// Constructor
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  StatisticsTimeFrame _selectedTimeFrame = StatisticsTimeFrame.month;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load statistics on init with a small delay to avoid build issues
    Future.microtask(() {
      ref.read(statisticsControllerProvider.notifier).loadStatistics();
    });
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

  void _onTimeFrameChanged(StatisticsTimeFrame timeFrame) {
    setState(() {
      _selectedTimeFrame = timeFrame;
    });
    ref.read(statisticsControllerProvider.notifier).updateTimeFrame(timeFrame);
  }

  void _goToPreviousPeriod() {
    ref.read(statisticsControllerProvider.notifier).previousPeriod();
  }

  void _goToNextPeriod() {
    ref.read(statisticsControllerProvider.notifier).nextPeriod();
  }

  @override
  Widget build(BuildContext context) {
    final statisticsState = ref.watch(statisticsControllerProvider);
    final dateRange = ref.watch(dateRangeProvider);

    // Date range formatter
    String periodText;
    switch (_selectedTimeFrame) {
      case StatisticsTimeFrame.day:
        periodText = DateFormat.yMMMd().format(dateRange.start);
      case StatisticsTimeFrame.week:
        final endDate = dateRange.end;
        periodText = '${DateFormat.MMMd().format(dateRange.start)} - '
            '${DateFormat.MMMd().format(endDate)}';
      case StatisticsTimeFrame.month:
        periodText = DateFormat.yMMM().format(dateRange.start);
      case StatisticsTimeFrame.quarter:
        final quarter = ((dateRange.start.month - 1) ~/ 3) + 1;
        periodText = 'Q$quarter ${dateRange.start.year}';
      case StatisticsTimeFrame.year:
        periodText = DateFormat.y().format(dateRange.start);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: statisticsState.when(
        data: (statistics) => _buildContent(statistics, periodText),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildContent(StatisticsModel? statistics, String periodText) {
    if (statistics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final timeSeriesData =
        ref.read(statisticsControllerProvider.notifier).getTimeSeriesData();

    final topCategories =
        ref.read(statisticsControllerProvider.notifier).getTopCategories(5);

    final formatter = NumberFormat.currency(symbol: r'$');

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(statisticsControllerProvider.notifier).loadStatistics();
      },
      child: ListView(
        controller: _scrollController,
        children: [
          // Time frame selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeFrameDropdown(),
                ),
                const SizedBox(width: 8),
                // Period navigator
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPreviousPeriod,
                  tooltip: 'Previous period',
                ),
                Text(
                  periodText,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _goToNextPeriod,
                  tooltip: 'Next period',
                ),
              ],
            ),
          ),

          // Summary card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Period Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // Income, expense, balance
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Income',
                            formatter.format(statistics.totalIncome),
                            Colors.green,
                            Icons.arrow_upward,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Expense',
                            formatter.format(statistics.totalExpense),
                            Colors.red,
                            Icons.arrow_downward,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Balance',
                            formatter.format(statistics.netBalance),
                            statistics.netBalance >= 0
                                ? Colors.green
                                : Colors.red,
                            statistics.netBalance >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    // Transaction count & average
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Transactions',
                            statistics.transactionCount.toString(),
                            Theme.of(context).colorScheme.primary,
                            Icons.receipt_long,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Average',
                            formatter.format(
                              statistics.averageTransactionAmount,
                            ),
                            Theme.of(context).colorScheme.tertiary,
                            Icons.calculate,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Category breakdown
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PieChartSection(categories: topCategories),
          ),

          // Income vs expense trend
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TrendChartSection(
              timeSeriesData: timeSeriesData,
              timeFrame: _selectedTimeFrame,
            ),
          ),

          // Add some bottom padding
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTimeFrameDropdown() {
    return DropdownButtonFormField<StatisticsTimeFrame>(
      value: _selectedTimeFrame,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        filled: true,
        fillColor:
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: StatisticsTimeFrame.day,
          child: Text('Daily'),
        ),
        DropdownMenuItem(
          value: StatisticsTimeFrame.week,
          child: Text('Weekly'),
        ),
        DropdownMenuItem(
          value: StatisticsTimeFrame.month,
          child: Text('Monthly'),
        ),
        DropdownMenuItem(
          value: StatisticsTimeFrame.quarter,
          child: Text('Quarterly'),
        ),
        DropdownMenuItem(
          value: StatisticsTimeFrame.year,
          child: Text('Yearly'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          _onTimeFrameChanged(value);
        }
      },
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(statisticsControllerProvider.notifier).loadStatistics();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
