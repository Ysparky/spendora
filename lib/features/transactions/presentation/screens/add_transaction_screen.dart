import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';
import 'package:spendora/features/transactions/presentation/controllers/transaction_controller.dart';

/// Screen for adding a new transaction
class AddTransactionScreen extends ConsumerStatefulWidget {
  /// Constructor
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String _category = 'Other';
  DateTime _date = DateTime.now();
  bool _isRecurring = false;
  String? _recurringFrequency;

  // Pre-defined categories
  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  // Recurring frequency options
  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        _showLoadingDialog();

        // Parse amount
        final amount = double.parse(_amountController.text);

        // Add transaction
        await ref.read(transactionControllerProvider.notifier).addTransaction(
              title: _titleController.text,
              amount: amount,
              category: _category,
              type: _type,
              description: _descriptionController.text.isEmpty
                  ? null
                  : _descriptionController.text,
              date: _date,
              isRecurring: _isRecurring,
              recurringFrequency: _recurringFrequency,
            );

        // Pop loading indicator and navigate back
        if (mounted) {
          // Pop loading dialog
          Navigator.of(context).pop();

          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          context.pop();
        }
      } on Exception catch (e) {
        // Pop loading indicator
        if (mounted) {
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding transaction: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showLoadingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 24),
            Text('Saving transaction...'),
          ],
        ),
      ),
    );
  }

  void _selectCategory() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Select Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final color =
                        AppColors.categoryColors[category.toLowerCase()] ??
                            AppColors.categoryColors['other']!;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(
                          index == 0
                              ? Icons.restaurant
                              : index == 1
                                  ? Icons.directions_car
                                  : index == 2
                                      ? Icons.shopping_cart
                                      : index == 3
                                          ? Icons.receipt
                                          : index == 4
                                              ? Icons.movie
                                              : index == 5
                                                  ? Icons.medical_services
                                                  : Icons.category,
                          color: color,
                        ),
                      ),
                      title: Text(category),
                      trailing: _category == category
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        setState(() {
                          _category = category;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        actions: [
          TextButton.icon(
            onPressed: _saveTransaction,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Transaction type toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<TransactionType>(
                        segments: const [
                          ButtonSegment<TransactionType>(
                            value: TransactionType.expense,
                            label: Text('Expense'),
                            icon: Icon(Icons.arrow_downward),
                          ),
                          ButtonSegment<TransactionType>(
                            value: TransactionType.income,
                            label: Text('Income'),
                            icon: Icon(Icons.arrow_upward),
                          ),
                        ],
                        selected: {_type},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _type = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount field
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: _type == TransactionType.expense
                      ? AppColors.expense
                      : AppColors.income,
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category field
            GestureDetector(
              onTap: _selectCategory,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: _category,
                    prefixIcon: const Icon(Icons.category),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: _category),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date field
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(),
                  ),
                  controller:
                      TextEditingController(text: dateFormatter.format(_date)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Recurring transaction toggle
            SwitchListTile(
              title: const Text('Recurring Transaction'),
              subtitle: const Text('Set this as a recurring transaction'),
              value: _isRecurring,
              onChanged: (value) {
                setState(() {
                  _isRecurring = value;
                  if (!value) {
                    _recurringFrequency = null;
                  }
                });
              },
            ),

            // Recurring frequency options
            if (_isRecurring) ...[
              const SizedBox(height: 8),
              const Text(
                'Frequency',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: _frequencies.map((frequency) {
                  final isSelected = _recurringFrequency == frequency;
                  return ChoiceChip(
                    label: Text(frequency),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _recurringFrequency = selected ? frequency : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
