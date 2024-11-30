import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/generated/locale_keys.g.dart';

class TransactionDetailBottomSheetModal extends StatelessWidget {
  // TODO: use right model here
  final Map<String, dynamic> transaction;

  const TransactionDetailBottomSheetModal._({required this.transaction});

  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> transaction,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TransactionDetailBottomSheetModal._(
        transaction: transaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(height: 4, width: 40, color: Colors.grey[300]),
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys.transaction_history_page_table_caption.tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildDetailRow(
            LocaleKeys.transaction_history_page_table_transaction_id.tr(),
            transaction['id'] ?? '',
          ),
          _buildDetailRow(
            LocaleKeys.transaction_history_page_table_date.tr(),
            transaction['date'] ?? '',
          ),
          _buildDetailRow(
            LocaleKeys.transaction_history_page_table_amount.tr(),
            transaction['amount'] ?? '',
          ),
          _buildDetailRow(
            LocaleKeys.transaction_history_page_table_bzc_quantity.tr(),
            transaction['amount'] ?? '',
          ),
          _buildDetailRow(
            LocaleKeys.transaction_history_page_table_status.tr(),
            transaction['status'] ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
