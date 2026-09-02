import 'dart:developer';

import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/bantu_wallet_localization.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/financial_transaction_entity.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import 'transaction_detail_bottom_sheet_modal.dart';

class TransactionItem extends StatelessWidget {
  final FinancialTransactionEntity transaction;

  const TransactionItem(this.transaction);

  static String getStatusText(EFinancialTxStatus status) {
    log(status.toString());
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
      case EFinancialTxType.debit:
        return LocaleKeys.wallet_module_transaction_history_page_type_DEPOSIT
            .tr();
      case EFinancialTxType.credit:
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
            DateFormat(
          'MMM d, yyyy HH:mm',
          BantuWalletLocalization.currentLanguageCode,
        ).format(transaction.createdAt),
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

  bool _isCredit() {
    return switch (transaction.type) {
      EFinancialTxType.deposit ||
      EFinancialTxType.credit ||
      EFinancialTxType.internalIn =>
        true,
      EFinancialTxType.debit ||
      EFinancialTxType.withdrawal ||
      EFinancialTxType.internalOut =>
        false,
    };
  }

  String _titleFor() {
    if (transaction.description != null &&
        transaction.description!.isNotEmpty) {
      return transaction.description!;
    }
    return getTypeText(transaction.type, transaction.paymentRef);
  }

  String _formatDate(DateTime date) {
    return DateFormat(
      'dd MMM yyyy • HH:mm',
      BantuWalletLocalization.currentLanguageCode,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = _isCredit();
    final amountColor =
        isCredit && transaction.status == EFinancialTxStatus.success
            ? const Color(0xFF2ECC71)
            : transaction.status == EFinancialTxStatus.failed
                ? Colors.red
                : Colors.black;
    final sign = isCredit ? '+' : '−';
    final amountText = '$sign${_getAmountSummary()}';

    final isCredited =
        isCredit && transaction.status == EFinancialTxStatus.success;
    final statusLabel = isCredited
        ? LocaleKeys.wallet_module_common_credited.tr()
        : transaction.status == EFinancialTxStatus.pending
            ? getStatusText(transaction.status).toUpperCase()
            : transaction.status == EFinancialTxStatus.failed
                ? getStatusText(transaction.status).toUpperCase()
                : LocaleKeys.wallet_module_common_successful.tr();
    final statusColor =
        isCredited ? const Color(0xFFDFF7E4) : const Color(0xFFF0F0F0);
    final statusTextColor = isCredited
        ? const Color(0xFF2ECC71)
        : transaction.status == EFinancialTxStatus.failed
            ? Colors.black45
            : Colors.black45;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onTap(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEFEFEF)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleFor(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: amountText,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: amountColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
