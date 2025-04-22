import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/statistics/domain/models/statistics_model.dart';
import 'package:spendora/features/statistics/presentation/controllers/statistics_controller.dart';

/// Chart type to display
enum ChartType {
  /// Line chart for trends
  line,

  /// Bar chart for comparison
  bar,
}

/// Widget that displays trend charts for income and expenses
class TrendChartSection extends StatefulWidget {
  /// Constructor
  const TrendChartSection({
    required this.timeSeriesData,
    required this.timeFrame,
    this.title = 'Income vs Expense Trend',
    this.defaultChartType = ChartType.line,
    super.key,
  });

  /// Time series data for the chart
  final List<TimeSeriesData> timeSeriesData;

  /// Time frame for the chart (affects date formatting)
  final StatisticsTimeFrame timeFrame;

  /// Title of the section
  final String title;

  /// Default chart type to show
  final ChartType defaultChartType;

  @override
  State<TrendChartSection> createState() => _TrendChartSectionState();
}

class _TrendChartSectionState extends State<TrendChartSection> {
  late ChartType _selectedChartType;
  bool _showIncome = true;
  bool _showExpense = true;
  bool _showBalance = false;

  @override
  void initState() {
    super.initState();
    _selectedChartType = widget.defaultChartType;
  }

  @override
  Widget build(BuildContext context) {
    // If there's no data, show empty state
    if (widget.timeSeriesData.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and controls
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.show_chart,
                      color: _selectedChartType == ChartType.line
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedChartType = ChartType.line;
                      });
                    },
                    tooltip: 'Line Chart',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bar_chart,
                      color: _selectedChartType == ChartType.bar
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedChartType = ChartType.bar;
                      });
                    },
                    tooltip: 'Bar Chart',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            height: 240,
            child: _selectedChartType == ChartType.line
                ? _buildLineChart()
                : _buildBarChart(),
          ),
        ),

        // Legend
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                context,
                'Income',
                AppColors.income,
                _showIncome,
                () {
                  setState(() {
                    _showIncome = !_showIncome;
                  });
                },
              ),
              _buildLegendItem(
                context,
                'Expense',
                AppColors.expense,
                _showExpense,
                () {
                  setState(() {
                    _showExpense = !_showExpense;
                  });
                },
              ),
              _buildLegendItem(
                context,
                'Balance',
                Theme.of(context).colorScheme.tertiary,
                _showBalance,
                () {
                  setState(() {
                    _showBalance = !_showBalance;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a clickable legend item
  Widget _buildLegendItem(
    BuildContext context,
    String label,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isActive ? 1.0 : 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build line chart for trends
  Widget _buildLineChart() {
    final data = widget.timeSeriesData;

    // Get max value for Y axis
    double maxY = 0;
    for (final point in data) {
      if (_showIncome) maxY = maxY < point.income ? point.income : maxY;
      if (_showExpense) maxY = maxY < point.expense ? point.expense : maxY;
      if (_showBalance) {
        maxY = maxY < point.balance.abs() ? point.balance.abs() : maxY;
      }
    }

    // Add 10% padding to max value
    maxY *= 1.1;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Only show a subset of dates to avoid overcrowding
                if (value % 2 != 0 && data.length > 6) {
                  return const SizedBox.shrink();
                }

                if (value < 0 || value >= data.length) {
                  return const SizedBox.shrink();
                }

                final date = data[value.toInt()].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length - 1.0,
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                String label;
                Color color;

                if (spot.barIndex == 0) {
                  label = 'Income: \$${spot.y.toStringAsFixed(2)}';
                  color = AppColors.income;
                } else if (spot.barIndex == 1) {
                  label = 'Expense: \$${spot.y.toStringAsFixed(2)}';
                  color = AppColors.expense;
                } else {
                  final balance = spot.y;
                  final prefix = balance >= 0 ? '+' : '';
                  label = 'Balance: $prefix\$${balance.toStringAsFixed(2)}';
                  color = Theme.of(context).colorScheme.tertiary;
                }

                return LineTooltipItem(
                  label,
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          if (_showIncome)
            LineChartBarData(
              spots: List.generate(data.length, (i) {
                return FlSpot(i.toDouble(), data[i].income);
              }),
              isCurved: true,
              color: AppColors.income,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.income.withOpacity(0.1),
              ),
            ),
          if (_showExpense)
            LineChartBarData(
              spots: List.generate(data.length, (i) {
                return FlSpot(i.toDouble(), data[i].expense);
              }),
              isCurved: true,
              color: AppColors.expense,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.expense.withOpacity(0.1),
              ),
            ),
          if (_showBalance)
            LineChartBarData(
              spots: List.generate(data.length, (i) {
                return FlSpot(i.toDouble(), data[i].balance);
              }),
              isCurved: true,
              color: Theme.of(context).colorScheme.tertiary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
              ),
            ),
        ],
      ),
    );
  }

  /// Build bar chart for comparison
  Widget _buildBarChart() {
    final data = widget.timeSeriesData;

    // Get max value for Y axis
    double maxY = 0;
    for (final point in data) {
      if (_showIncome) maxY = maxY < point.income ? point.income : maxY;
      if (_showExpense) maxY = maxY < point.expense ? point.expense : maxY;
      if (_showBalance) {
        maxY = maxY < point.balance.abs() ? point.balance.abs() : maxY;
      }
    }

    // Add 10% padding to max value
    maxY *= 1.1;

    return BarChart(
      BarChartData(
        gridData: const FlGridData(
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Only show a subset of dates to avoid overcrowding
                if (value % 2 != 0 && data.length > 6) {
                  return const SizedBox.shrink();
                }

                if (value < 0 || value >= data.length) {
                  return const SizedBox.shrink();
                }

                final date = data[value.toInt()].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (i) {
          final barRods = <BarChartRodData>[];
          var rodIndex = 0;

          if (_showIncome) {
            barRods.add(
              BarChartRodData(
                toY: data[i].income,
                color: AppColors.income,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
            );
            rodIndex++;
          }

          if (_showExpense) {
            barRods.add(
              BarChartRodData(
                toY: data[i].expense,
                color: AppColors.expense,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
            );
            rodIndex++;
          }

          if (_showBalance) {
            barRods.add(
              BarChartRodData(
                toY: data[i].balance,
                color: Theme.of(context).colorScheme.tertiary,
                width: 12,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                ),
              ),
            );
          }

          return BarChartGroupData(
            x: i,
            barRods: barRods,
            barsSpace: 4,
          );
        }),
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            fitInsideVertically: true,
            fitInsideHorizontally: true,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label;
              Color color;

              if (!_showIncome && !_showExpense && _showBalance) {
                // Only balance is shown
                final balance = rod.toY;
                final prefix = balance >= 0 ? '+' : '';
                label = 'Balance: $prefix\$${balance.toStringAsFixed(2)}';
                color = Theme.of(context).colorScheme.tertiary;
              } else if (!_showIncome && _showExpense && _showBalance) {
                // Expense and balance
                if (rodIndex == 0) {
                  label = 'Expense: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.expense;
                } else {
                  final balance = rod.toY;
                  final prefix = balance >= 0 ? '+' : '';
                  label = 'Balance: $prefix\$${balance.toStringAsFixed(2)}';
                  color = Theme.of(context).colorScheme.tertiary;
                }
              } else if (_showIncome && !_showExpense && _showBalance) {
                // Income and balance
                if (rodIndex == 0) {
                  label = 'Income: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.income;
                } else {
                  final balance = rod.toY;
                  final prefix = balance >= 0 ? '+' : '';
                  label = 'Balance: $prefix\$${balance.toStringAsFixed(2)}';
                  color = Theme.of(context).colorScheme.tertiary;
                }
              } else if (_showIncome && _showExpense && !_showBalance) {
                // Income and expense
                if (rodIndex == 0) {
                  label = 'Income: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.income;
                } else {
                  label = 'Expense: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.expense;
                }
              } else if (_showIncome && !_showExpense && !_showBalance) {
                // Only income
                label = 'Income: \$${rod.toY.toStringAsFixed(2)}';
                color = AppColors.income;
              } else if (!_showIncome && _showExpense && !_showBalance) {
                // Only expense
                label = 'Expense: \$${rod.toY.toStringAsFixed(2)}';
                color = AppColors.expense;
              } else {
                // All three
                if (rodIndex == 0) {
                  label = 'Income: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.income;
                } else if (rodIndex == 1) {
                  label = 'Expense: \$${rod.toY.toStringAsFixed(2)}';
                  color = AppColors.expense;
                } else {
                  final balance = rod.toY;
                  final prefix = balance >= 0 ? '+' : '';
                  label = 'Balance: $prefix\$${balance.toStringAsFixed(2)}';
                  color = Theme.of(context).colorScheme.tertiary;
                }
              }

              return BarTooltipItem(
                label,
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Format date based on time frame
  String _formatDate(DateTime date) {
    switch (widget.timeFrame) {
      case StatisticsTimeFrame.day:
        return DateFormat('h a').format(date);
      case StatisticsTimeFrame.week:
        return DateFormat('EEE').format(date);
      case StatisticsTimeFrame.month:
        return DateFormat('d').format(date);
      case StatisticsTimeFrame.quarter:
        return DateFormat('MMM').format(date);
      case StatisticsTimeFrame.year:
        return DateFormat('MMM').format(date);
    }
  }

  /// Build empty state when there's no data
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 220,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 60,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No trend data for this period',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
