import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/financial_transaction_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/transactions/widgets/transaction_item.dart';

class TransactionFilter extends StatelessWidget {
  final EFinancialTxType? selectedType;
  final EFinancialTxStatus? selectedStatus;
  final void Function(EFinancialTxType)? onTypeTap;
  final void Function(EFinancialTxStatus)? onStatusTap;
  final void Function() onAllTap;

  const TransactionFilter({
    required this.selectedType,
    required this.selectedStatus,
    required this.onAllTap,
    this.onTypeTap,
    this.onStatusTap,
  }) : assert(onTypeTap == null || onStatusTap == null);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _FilterChip(
              label: LocaleKeys.wallet_module_common_all.tr(),
              isSelected: selectedType == null && selectedStatus == null,
              onSelected: (bool selected) => onAllTap(),
            ),
          ),
          if (onTypeTap != null)
            ...[EFinancialTxType.internalIn, EFinancialTxType.internalOut].map(
              (type) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FilterChip(
                  label: TransactionItem.getTypeText(type, 'BZCExchange'),
                  isSelected: selectedType == type,
                  onSelected: (bool selected) => onTypeTap!(type),
                ),
              ),
            ),
          if (onStatusTap != null)
            ...EFinancialTxStatus.values.map(
              (status) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _FilterChip(
                  label: TransactionItem.getStatusText(status),
                  isSelected: selectedStatus == status,
                  onSelected: (bool selected) => onStatusTap!(status),
                ),
              ),
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
