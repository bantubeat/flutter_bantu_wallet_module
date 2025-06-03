import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../core/generated/locale_keys.g.dart';

class TransactionDetailBottomSheetModal extends StatelessWidget {
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
        ],
      ),
    );
  }
}
