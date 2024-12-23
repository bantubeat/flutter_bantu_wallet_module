import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/financial_transaction_entity.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import 'transaction_detail_bottom_sheet_modal.dart';

class TransactionItem extends StatelessWidget {
  final FinancialTransactionEntity transaction;

  const TransactionItem(this.transaction);

  Color _getStatusColor() {
    switch (transaction.status) {
      case EFinancialTxStatus.failed:
        return Colors.red;
      case EFinancialTxStatus.pending:
        return Colors.blue;
      case EFinancialTxStatus.success:
        return Colors.green;
    }
  }

  static String getStatusText(EFinancialTxStatus status) {
    switch (status) {
      case EFinancialTxStatus.failed:
        return LocaleKeys.wallet_module_transaction_history_page_status_FAILED
            .tr();
      case EFinancialTxStatus.pending:
        return LocaleKeys.wallet_module_transaction_history_page_status_PENDING
            .tr();
      case EFinancialTxStatus.success:
        return LocaleKeys.wallet_module_transaction_history_page_status_SUCCESS
            .tr();
    }
  }

  static String getTypeText(EFinancialTxType type, [String paymentRef = '']) {
    switch (type) {
      case EFinancialTxType.deposit:
        return LocaleKeys.wallet_module_transaction_history_page_type_DEPOSIT
            .tr();
      case EFinancialTxType.withdrawal:
        return LocaleKeys.wallet_module_transaction_history_page_type_WITHDRAWAL
            .tr();
      case EFinancialTxType.internalIn:
        if (paymentRef.contains('BZCExchange')) {
          return LocaleKeys
              .wallet_module_transaction_history_page_type_INTERNAL_IN_bzc
              .tr();
        } else {
          return LocaleKeys
              .wallet_module_transaction_history_page_type_INTERNAL_IN
              .tr();
        }
      case EFinancialTxType.internalOut:
        if (paymentRef.contains('BZCExchange')) {
          return LocaleKeys
              .wallet_module_transaction_history_page_type_INTERNAL_OUT_bzc
              .tr();
        } else {
          return LocaleKeys
              .wallet_module_transaction_history_page_type_INTERNAL_OUT
              .tr();
        }
    }
  }

  String _getAmountSummary() {
    final eurAmount = NumberFormat.currency(name: 'EUR', symbol: '€').format(
      transaction.amount,
    );
    if (['EUR'].contains(transaction.inputCurrency)) return eurAmount;

    return NumberFormat.currency(
      name: transaction.inputCurrency,
      symbol: transaction.inputCurrency.toUpperCase() == 'BZC' ? 'BZC' : null,
    ).format(transaction.inputAmount);
  }

  void _onTap(BuildContext context) {
    final eurFormatter = NumberFormat.currency(name: 'EUR', symbol: '€');
    TransactionDetailBottomSheetModal.show(
      context,
      transactionMap: <String, String>{
        LocaleKeys.wallet_module_transaction_history_page_table_transaction_id
            .tr(): '# ${transaction.id}',
        LocaleKeys.wallet_module_transaction_history_page_table_transaction_ref
            .tr(): transaction.paymentRef,
        LocaleKeys.wallet_module_transaction_history_page_table_amount.tr():
            eurFormatter.format(transaction.amount),
        if (transaction.inputCurrency == 'BZC')
          LocaleKeys.wallet_module_transaction_history_page_table_bzc_quantity
              .tr(): NumberFormat.currency(symbol: 'BZC').format(
            transaction.inputAmount,
          ),
        if (false == ['EUR', 'BZC'].contains(transaction.inputCurrency))
          LocaleKeys.wallet_module_transaction_history_page_table_input_amount
              .tr(): NumberFormat.currency(
            name: transaction.inputCurrency,
          ).format(transaction.inputAmount),
        LocaleKeys.wallet_module_transaction_history_page_table_status.tr():
            getStatusText(transaction.status),
        LocaleKeys.wallet_module_transaction_history_page_table_type.tr():
            getTypeText(transaction.type, transaction.paymentRef),
        LocaleKeys.wallet_module_transaction_history_page_table_old_balance
            .tr(): eurFormatter.format(transaction.oldBalance),
        LocaleKeys.wallet_module_transaction_history_page_table_new_balance
            .tr(): eurFormatter.format(transaction.newBalance),
        LocaleKeys.wallet_module_transaction_history_page_table_date.tr():
            DateFormat('MMM d, yyyy HH:mm').format(transaction.createdAt),
        LocaleKeys.wallet_module_transaction_history_page_table_payment_method
            .tr(): transaction.paymentMethod,
        LocaleKeys.wallet_module_transaction_history_page_table_description
            .tr(): transaction.description ?? '',
      },
    );
  }

  String shortenText(String text, [int maxLength = 15]) {
    final middle = (maxLength - 3) ~/ 2;
    if (text.length > maxLength) {
      return '${text.substring(0, middle)}...${text.substring(text.length - middle)}';
    } else {
      return text; // Use the full text if it's already short
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _onTap(context),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${getTypeText(transaction.type, transaction.paymentRef)} | ${shortenText(transaction.paymentRef)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy HH:mm')
                        .format(transaction.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getAmountSummary(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    transaction.status.value,
                    style: TextStyle(color: _getStatusColor(), fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
