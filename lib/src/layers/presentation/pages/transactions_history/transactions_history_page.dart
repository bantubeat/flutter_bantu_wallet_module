import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/generated/locale_keys.g.dart';
import 'widgets/transaction_filter.dart';
import 'widgets/transaction_list.dart';

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(
              LocaleKeys.wallet_module_transaction_history_page_title.tr()),
          bottom: TabBar(
            tabs: [
              Tab(
                text: LocaleKeys
                    .wallet_module_transaction_history_page_financial_account
                    .tr(),
              ),
              Tab(
                text: LocaleKeys
                    .wallet_module_transaction_history_page_beatzocoin_account
                    .tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTransactionTab(isFinancial: true),
            _buildTransactionTab(isFinancial: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTab({required bool isFinancial}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Row(
            children: [
              Text(
                LocaleKeys.wallet_module_transaction_history_page_account.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              /*
              Flexible(child: FittedBox(child: Text('(ID: 248152526526525)'))),
							*/
            ],
          ),
        ),
        const TransactionFilter(),
        Expanded(child: TransactionList(isFinancial: isFinancial)),
      ],
    );
  }
}
