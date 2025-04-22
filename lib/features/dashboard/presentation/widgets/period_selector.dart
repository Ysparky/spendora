import 'package:flutter/material.dart';

/// Widget for selecting time period
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onPeriodChanged,
    super.key,
  });

  final List<String> periods;
  final int selectedIndex;
  final void Function(int) onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(periods.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(periods[index]),
              selected: selectedIndex == index,
              onSelected: (selected) {
                if (selected) {
                  onPeriodChanged(index);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
