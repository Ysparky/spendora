import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';

class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Typography', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text('Display Large', style: theme.textTheme.displayLarge),
            Text('Display Medium', style: theme.textTheme.displayMedium),
            Text('Display Small', style: theme.textTheme.displaySmall),
            const SizedBox(height: 16),
            Text('Headline Large', style: theme.textTheme.headlineLarge),
            Text('Headline Medium', style: theme.textTheme.headlineMedium),
            Text('Headline Small', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Title Large', style: theme.textTheme.titleLarge),
            Text('Title Medium', style: theme.textTheme.titleMedium),
            Text('Title Small', style: theme.textTheme.titleSmall),
            const SizedBox(height: 16),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            Text('Body Medium', style: theme.textTheme.bodyMedium),
            Text('Body Small', style: theme.textTheme.bodySmall),
            const SizedBox(height: 32),
            Text('Colors', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorBox(
                  color: colorScheme.primary,
                  label: 'Primary',
                ),
                _ColorBox(
                  color: colorScheme.secondary,
                  label: 'Secondary',
                ),
                _ColorBox(
                  color: AppColors.expense,
                  label: 'Expense',
                ),
                _ColorBox(
                  color: AppColors.income,
                  label: 'Income',
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Components', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Text Field',
                hintText: 'Enter some text',
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card Title', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'This is a card component with some content to showcase the elevation and padding.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorBox({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
