import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/statistics/data/providers/statistics_providers.dart';
import 'package:spendora/features/statistics/domain/models/statistics_model.dart';

part 'statistics_controller.g.dart';

/// Controller for statistics feature
@riverpod
class StatisticsController extends _$StatisticsController {
  @override
  AsyncValue<StatisticsModel?> build() {
    // Initialize with loading state
    return const AsyncLoading();
  }

  /// Get the current user ID
  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to perform this action');
    }
    return user.uid;
  }

  /// Load statistics for the current time frame and date range
  Future<void> loadStatistics() async {
    state = const AsyncLoading();

    try {
      final timeFrame = ref.read(timeFrameProvider);
      final dateRange = ref.read(dateRangeProvider);

      // Fetch transactions for the date range
      final repository = ref.read(transactionRepositoryForStatsProvider);
      final transactionsStream = repository.getTransactionsByDateRange(
        _userId,
        dateRange.start,
        dateRange.end,
      );

      // Process the first value from the stream
      final transactions = await transactionsStream.first;

      // Create statistics model from transactions
      final statistics = StatisticsModel.fromTransactions(
        transactions: transactions,
        timeFrame: timeFrame,
        startDate: dateRange.start,
        endDate: dateRange.end,
      );

      state = AsyncData(statistics);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(
        'Failed to load statistics: $error',
        stackTrace,
      );
    }
  }

  /// Update the selected time frame and reload statistics
  Future<void> updateTimeFrame(StatisticsTimeFrame timeFrame) async {
    ref.read(timeFrameProvider.notifier).state = timeFrame;
    await loadStatistics();
  }

  /// Go to previous period and reload statistics
  Future<void> previousPeriod() async {
    final timeFrame = ref.read(timeFrameProvider);
    final currentRange = ref.read(dateRangeProvider);

    // Calculate new date range based on time frame
    final newRange = _shiftDateRange(currentRange, timeFrame, forward: false);
    ref.read(dateRangeProvider.notifier).state = newRange;

    await loadStatistics();
  }

  /// Go to next period and reload statistics
  Future<void> nextPeriod() async {
    final timeFrame = ref.read(timeFrameProvider);
    final currentRange = ref.read(dateRangeProvider);

    // Calculate new date range based on time frame
    final newRange = _shiftDateRange(currentRange, timeFrame, forward: true);
    ref.read(dateRangeProvider.notifier).state = newRange;

    await loadStatistics();
  }

  /// Shift date range forward or backward by one period
  DateTimeRange _shiftDateRange(
    DateTimeRange range,
    StatisticsTimeFrame timeFrame, {
    required bool forward,
  }) {
    final direction = forward ? 1 : -1;
    late DateTime newStart;
    late DateTime newEnd;

    switch (timeFrame) {
      case StatisticsTimeFrame.day:
        newStart = DateTime(
          range.start.year,
          range.start.month,
          range.start.day + direction,
        );
        newEnd = newStart;
      case StatisticsTimeFrame.week:
        newStart = DateTime(
          range.start.year,
          range.start.month,
          range.start.day + (7 * direction),
        );
        newEnd = DateTime(
          newStart.year,
          newStart.month,
          newStart.day + 6,
        );
      case StatisticsTimeFrame.month:
        newStart = DateTime(
          range.start.year,
          range.start.month + direction,
        );
        newEnd = DateTime(
          newStart.year,
          newStart.month + 1,
          0,
        );
      case StatisticsTimeFrame.quarter:
        newStart = DateTime(
          range.start.year,
          range.start.month + (3 * direction),
        );
        newEnd = DateTime(
          newStart.year,
          newStart.month + 3,
          0,
        );
      case StatisticsTimeFrame.year:
        newStart = DateTime(range.start.year + direction);
        newEnd = DateTime(newStart.year, 12, 31);
    }

    return DateTimeRange(start: newStart, end: newEnd);
  }

  /// Get top spending categories for pie chart
  List<CategorySpending> getTopCategories(int limit) {
    if (state.value == null) return [];

    final categoryBreakdown = state.value!.categoryBreakdown;
    final topCategories = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Convert to CategorySpending objects
    final result = topCategories
        .take(limit)
        .map((e) => CategorySpending(category: e.key, amount: e.value))
        .toList();

    // Add "Other" category if there are more categories than the limit
    if (topCategories.length > limit) {
      double otherAmount = 0;
      for (var i = limit; i < topCategories.length; i++) {
        otherAmount += topCategories[i].value;
      }
      result.add(CategorySpending(category: 'other', amount: otherAmount));
    }

    return result;
  }

  /// Get time series data for line/bar charts
  List<TimeSeriesData> getTimeSeriesData() {
    if (state.value == null) return [];

    final timeSeriesMap = state.value!.timeSeriesData;
    final result = <TimeSeriesData>[];

    // Sort dates chronologically
    final sortedDates = timeSeriesMap.keys.toList()..sort();

    for (final date in sortedDates) {
      final data = timeSeriesMap[date]!;
      result.add(
        TimeSeriesData(
          date: date,
          income: data['income'] ?? 0,
          expense: data['expense'] ?? 0,
        ),
      );
    }

    return result;
  }
}

/// Model for category spending data
class CategorySpending {
  /// Creates a new category spending
  CategorySpending({required this.category, required this.amount});

  /// Category name
  final String category;

  /// Amount spent in this category
  final double amount;
}

/// Model for time series data
class TimeSeriesData {
  /// Creates a new time series data point
  TimeSeriesData({
    required this.date,
    required this.income,
    required this.expense,
  });

  /// Date for this data point
  final DateTime date;

  /// Income amount
  final double income;

  /// Expense amount
  final double expense;

  /// Net balance (income - expense)
  double get balance => income - expense;
}
