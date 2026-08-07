import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/pdf_printer.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../core/generated/locale_keys.g.dart';

class TransactionDetailBottomSheetModal extends StatefulWidget {
  final Map<String, String> transactionMap;

  const TransactionDetailBottomSheetModal._(this.transactionMap);

  static Future<void> show(
    BuildContext context, {
    required Map<String, String> transactionMap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TransactionDetailBottomSheetModal._(transactionMap),
    );
  }

  @override
  State<TransactionDetailBottomSheetModal> createState() =>
      _TransactionDetailBottomSheetModalState();
}

class _TransactionDetailBottomSheetModalState
    extends State<TransactionDetailBottomSheetModal> {
  bool _isGeneratingPdf = false;

  Future<void> _handlePrint() async {
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);
    try {
      await printDetailsPdf(
        title: LocaleKeys
            .wallet_module_transaction_history_page_table_caption
            .tr(),
        details: widget.transactionMap,
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionMap = widget.transactionMap;
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
          const SizedBox(height: 20),
          Text(
            LocaleKeys.wallet_module_transaction_history_page_table_caption
                .tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          for (final key in transactionMap.keys)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        transactionMap[key] ?? '',
                        softWrap: true,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGeneratingPdf ? null : _handlePrint,
              icon: _isGeneratingPdf
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black87,
                      ),
                    )
                  : const Icon(Icons.print, size: 18, color: Colors.black87),
              label: Text(
                _isGeneratingPdf
                    ? LocaleKeys.wallet_module_payment_success_page_generating_receipt
                        .tr()
                    : LocaleKeys.wallet_module_common_print.tr(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
