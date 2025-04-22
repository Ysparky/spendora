import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

/// Model for statistics data in different time periods
class StatisticsModel {
  /// Creates a new statistics model
  StatisticsModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.categoryBreakdown,
    required this.transactionCount,
    required this.averageTransactionAmount,
    required this.timeSeriesData,
    required this.periodLabel,
  });

  /// Factory method to create statistics from transactions
  factory StatisticsModel.fromTransactions({
    required List<TransactionModel> transactions,
    required StatisticsTimeFrame timeFrame,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Initialize values
    double totalIncome = 0;
    double totalExpense = 0;
    final categoryBreakdown = <String, double>{};
    final timeSeriesData = <DateTime, Map<String, double>>{};

    // Initialize time series buckets based on time frame
    final dateRange = _generateDateRange(startDate, endDate, timeFrame);
    for (final date in dateRange) {
      timeSeriesData[date] = {'income': 0, 'expense': 0};
    }

    // Process transactions
    for (final transaction in transactions) {
      // Update income/expense totals
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
        // Update category breakdown (only for expenses)
        final category = transaction.category.toLowerCase();
        categoryBreakdown[category] =
            (categoryBreakdown[category] ?? 0) + transaction.amount;
      }

      // Find the appropriate time bucket and update time series data
      final bucketDate = _getBucketDate(transaction.date, timeFrame);
      if (timeSeriesData.containsKey(bucketDate)) {
        if (transaction.type == TransactionType.income) {
          timeSeriesData[bucketDate]!['income'] =
              (timeSeriesData[bucketDate]!['income'] ?? 0) + transaction.amount;
        } else {
          timeSeriesData[bucketDate]!['expense'] =
              (timeSeriesData[bucketDate]!['expense'] ?? 0) +
                  transaction.amount;
        }
      }
    }

    // Calculate derived statistics
    final netBalance = totalIncome - totalExpense;
    final transactionCount = transactions.length;
    final averageTransactionAmount = transactionCount > 0
        ? (totalIncome + totalExpense) / transactionCount.toDouble()
        : 0.0;

    // Generate period label
    final periodLabel = _generatePeriodLabel(startDate, endDate, timeFrame);

    return StatisticsModel(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: netBalance,
      categoryBreakdown: categoryBreakdown,
      transactionCount: transactionCount,
      averageTransactionAmount: averageTransactionAmount,
      timeSeriesData: timeSeriesData,
      periodLabel: periodLabel,
    );
  }

  /// Total income for the period
  final double totalIncome;

  /// Total expense for the period
  final double totalExpense;

  /// Net balance (income - expense)
  final double netBalance;

  /// Breakdown of expenses by category
  final Map<String, double> categoryBreakdown;

  /// Total number of transactions in the period
  final int transactionCount;

  /// Average transaction amount
  final double averageTransactionAmount;

  /// Time series data for charts
  /// Map key is the date (day, month, or year depending on view)
  /// Value is a map with 'income' and 'expense' entries
  final Map<DateTime, Map<String, double>> timeSeriesData;

  /// Label for the period (e.g., "July 2023", "Q3 2023", "2023")
  final String periodLabel;

  /// Generate a list of dates for the time series based on time frame
  static List<DateTime> _generateDateRange(
    DateTime start,
    DateTime end,
    StatisticsTimeFrame timeFrame,
  ) {
    final range = <DateTime>[];
    var current = _getBucketDate(start, timeFrame);
    final endBucket = _getBucketDate(end, timeFrame);

    while (current.isBefore(endBucket) || current.isAtSameMomentAs(endBucket)) {
      range.add(current);
      switch (timeFrame) {
        case StatisticsTimeFrame.day:
          current = DateTime(current.year, current.month, current.day + 1);
        case StatisticsTimeFrame.week:
          current = DateTime(current.year, current.month, current.day + 7);
        case StatisticsTimeFrame.month:
          current = DateTime(current.year, current.month + 1);
        case StatisticsTimeFrame.quarter:
          current = DateTime(current.year, current.month + 3);
        case StatisticsTimeFrame.year:
          current = DateTime(current.year + 1);
      }
    }

    return range;
  }

  /// Get the appropriate date bucket for a transaction based on time frame
  static DateTime _getBucketDate(DateTime date, StatisticsTimeFrame timeFrame) {
    switch (timeFrame) {
      case StatisticsTimeFrame.day:
        return DateTime(date.year, date.month, date.day);
      case StatisticsTimeFrame.week:
        // Find the start of the week (Monday)
        final weekday = date.weekday;
        return DateTime(date.year, date.month, date.day - weekday + 1);
      case StatisticsTimeFrame.month:
        return DateTime(date.year, date.month);
      case StatisticsTimeFrame.quarter:
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return DateTime(date.year, (quarter - 1) * 3 + 1);
      case StatisticsTimeFrame.year:
        return DateTime(date.year);
    }
  }

  /// Generate a human-readable label for the period
  static String _generatePeriodLabel(
    DateTime start,
    DateTime end,
    StatisticsTimeFrame timeFrame,
  ) {
    switch (timeFrame) {
      case StatisticsTimeFrame.day:
        return '${start.month}/${start.day}/${start.year}';
      case StatisticsTimeFrame.week:
        return 'Week of ${start.month}/${start.day}/${start.year}';
      case StatisticsTimeFrame.month:
        return '${_getMonthName(start.month)} ${start.year}';
      case StatisticsTimeFrame.quarter:
        final quarter = ((start.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${start.year}';
      case StatisticsTimeFrame.year:
        return '${start.year}';
    }
  }

  /// Get month name from month number
  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

/// Time frames for statistics views
enum StatisticsTimeFrame {
  /// Daily view
  day,

  /// Weekly view
  week,

  /// Monthly view
  month,

  /// Quarterly view
  quarter,

  /// Yearly view
  year,
}
