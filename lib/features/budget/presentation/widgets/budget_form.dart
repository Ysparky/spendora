import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/budget/domain/models/budget_model.dart';

/// A form for creating or editing a budget
class BudgetForm extends StatefulWidget {
  /// Constructor
  const BudgetForm({
    this.initialBudget,
    required this.onSubmit,
    this.isLoading = false,
    super.key,
  });

  /// Initial budget to edit, or null for creating a new budget
  final BudgetModel? initialBudget;

  /// Callback when the form is submitted
  final void Function({
    required String category,
    required double amount,
    required BudgetPeriod period,
    DateTime? startDate,
    DateTime? endDate,
    required bool isActive,
    String? notes,
  }) onSubmit;

  /// Whether the form is loading
  final bool isLoading;

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'food';
  BudgetPeriod _selectedPeriod = BudgetPeriod.monthly;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = true;

  // Available category options
  final List<Map<String, dynamic>> _categories = [
    {'value': 'food', 'label': 'Food & Drinks', 'icon': Icons.restaurant},
    {
      'value': 'transport',
      'label': 'Transportation',
      'icon': Icons.directions_car
    },
    {'value': 'shopping', 'label': 'Shopping', 'icon': Icons.shopping_cart},
    {'value': 'bills', 'label': 'Bills & Utilities', 'icon': Icons.receipt},
    {'value': 'entertainment', 'label': 'Entertainment', 'icon': Icons.movie},
    {'value': 'health', 'label': 'Healthcare', 'icon': Icons.medical_services},
    {'value': 'other', 'label': 'Other', 'icon': Icons.category},
  ];

  @override
  void initState() {
    super.initState();

    // Set initial values if editing an existing budget
    if (widget.initialBudget != null) {
      _selectedCategory = widget.initialBudget!.category;
      _amountController.text = widget.initialBudget!.amount.toString();
      _selectedPeriod = widget.initialBudget!.period;
      _startDate = widget.initialBudget!.startDate;
      _endDate = widget.initialBudget!.endDate;
      _isActive = widget.initialBudget!.isActive;
      _notesController.text = widget.initialBudget!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Pick a date
  Future<void> _pickDate(bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: isStartDate
          ? DateTime(DateTime.now().year - 1)
          : _startDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          // If end date is before start date, update it
          if (_endDate != null && _endDate!.isBefore(pickedDate)) {
            _endDate = pickedDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  // Submit the form
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final double amount = double.tryParse(_amountController.text) ?? 0;

      widget.onSubmit(
        category: _selectedCategory,
        amount: amount,
        period: _selectedPeriod,
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category selection
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
            children: _categories.map((category) {
              final isSelected =
                  _selectedCategory == category['value'] as String;
              final categoryColor =
                  AppColors.categoryColors[category['value'] as String] ??
                      AppColors.categoryColors['other']!;

              return ChoiceChip(
                label: Text(category['label'] as String),
                selected: isSelected,
                onSelected: widget.isLoading
                    ? null
                    : (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = category['value'] as String;
                          });
                        }
                      },
                avatar: Icon(
                  category['icon'] as IconData,
                  size: 16,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : categoryColor,
                ),
                selectedColor: categoryColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Amount input
          Text(
            'Budget Amount',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              prefixText: '\$ ',
              hintText: '0.00',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabled: !widget.isLoading,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.parse(value) <= 0) {
                return 'Amount must be greater than zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Period selection
          Text(
            'Budget Period',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<BudgetPeriod>(
            value: _selectedPeriod,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabled: !widget.isLoading,
            ),
            items: BudgetPeriod.values.map((period) {
              return DropdownMenuItem<BudgetPeriod>(
                value: period,
                child: Text(period.displayName),
              );
            }).toList(),
            onChanged: widget.isLoading
                ? null
                : (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
          ),
          const SizedBox(height: 24),

          // Date range
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date (Optional)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: widget.isLoading ? null : () => _pickDate(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startDate == null
                                  ? 'Select Date'
                                  : '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}',
                              style: TextStyle(
                                color: _startDate == null
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                    : null,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End Date (Optional)',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: widget.isLoading ? null : () => _pickDate(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _endDate == null
                                  ? 'Select Date'
                                  : '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',
                              style: TextStyle(
                                color: _endDate == null
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                    : null,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Active toggle
          SwitchListTile(
            title: Text(
              'Active Budget',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: const Text(
              'Track spending against this budget',
            ),
            value: _isActive,
            onChanged: widget.isLoading
                ? null
                : (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),

          // Notes input
          Text(
            'Notes (Optional)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Add notes or reminders about this budget',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabled: !widget.isLoading,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: widget.isLoading ? null : _submitForm,
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.initialBudget == null
                          ? 'Create Budget'
                          : 'Update Budget',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
