import 'package:flutter/material.dart';
import 'widgets/transaction_filter.dart';
import 'widgets/transaction_list.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historique portefeuille'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Compte Financier'),
              Tab(text: 'Compte Beatzcoin'),
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
        const TransactionFilter(),
        Expanded(
          child: TransactionList(
            isFinancial: isFinancial,
          ),
        ),
      ],
    );
  }
}
