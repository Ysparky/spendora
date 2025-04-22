import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/statistics/domain/models/statistics_model.dart';
import 'package:spendora/features/transactions/data/providers/transaction_providers.dart';
import 'package:spendora/features/transactions/domain/repositories/transaction_repository.dart';

/// Provider for the transaction repository
final transactionRepositoryForStatsProvider = Provider<TransactionRepository>(
  (ref) => ref.watch(transactionRepositoryProvider),
);

/// Provider for the current time frame
final timeFrameProvider = StateProvider<StatisticsTimeFrame>(
  (ref) => StatisticsTimeFrame.month, // Default to monthly view
);

/// Provider for the current date range
final dateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  final timeFrame = ref.watch(timeFrameProvider);

  // Calculate start and end dates based on time frame
  late DateTime start;
  late DateTime end;

  switch (timeFrame) {
    case StatisticsTimeFrame.day:
      start = DateTime(now.year, now.month, now.day);
      end = start;
    case StatisticsTimeFrame.week:
      // Start from Monday of the current week
      final daysFromMonday = now.weekday - 1;
      start = DateTime(now.year, now.month, now.day - daysFromMonday);
      end = DateTime(start.year, start.month, start.day + 6);
    case StatisticsTimeFrame.month:
      start = DateTime(now.year, now.month);
      end = DateTime(now.year, now.month + 1, 0);
    case StatisticsTimeFrame.quarter:
      final currentQuarter = ((now.month - 1) ~/ 3) + 1;
      start = DateTime(now.year, (currentQuarter - 1) * 3 + 1);
      end = DateTime(now.year, currentQuarter * 3 + 1, 0);
    case StatisticsTimeFrame.year:
      start = DateTime(now.year);
      end = DateTime(now.year, 12, 31);
  }

  return DateTimeRange(start: start, end: end);
});

/// Class representing a date range
class DateTimeRange {
  DateTimeRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}
