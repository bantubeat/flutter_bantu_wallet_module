
import 'package:flutter/material.dart';

class TransactionFilter extends StatelessWidget {
  const TransactionFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: true,
            onSelected: (bool selected) {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Complete',
            isSelected: false,
            onSelected: (bool selected) {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pending',
            isSelected: false,
            onSelected: (bool selected) {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Rejected',
            isSelected: false,
            onSelected: (bool selected) {},
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}