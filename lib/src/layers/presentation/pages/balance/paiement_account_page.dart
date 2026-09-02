import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/financial_transaction_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_transactions_history_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/transactions/widgets/transaction_item.dart'
    show TransactionItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../home/widgets/menu_tile.dart';

class PaiementAccountPage extends StatefulWidget {
  const PaiementAccountPage({super.key});

  @override
  State<PaiementAccountPage> createState() => _PaiementAccountPageState();
}

class _PaiementAccountPageState extends State<PaiementAccountPage> {
  List<FinancialTransactionEntity>? _transactions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() => _isLoading = true);
    try {
      final items = await Modular.get<GetTransactionsUseCase>().call(
        const GetTransactionsParams(
          page: 1,
          limit: 5,
          statuses: [],
          types: [],
          accountType: AccountType.payment,
        ),
      );
      if (mounted) {
        setState(() {
          _transactions = items;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void addFund() => Modular.get<WalletRoutes>().deposit.push();
  void _openHistory() => Modular.get<WalletRoutes>().transactions.push();

  @override
  Widget build(BuildContext context) {
    final userBalanceCubit = Modular.get<UserBalanceCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: InkWell(
          onTap: Modular.to.canPop() ? Modular.to.pop : null,
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: false,
        title: Text(
          LocaleKeys.wallet_module_featlink_home_page_title.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await userBalanceCubit.fetchUserBalance();
          await _fetchTransactions();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                LocaleKeys.wallet_module_featlink_home_page_account_management
                    .tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.wallet_module_payment_account_title.tr(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Carte solde
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocSelector<
                        UserBalanceCubit,
                        AsyncSnapshot<UserBalanceEntity>,
                        PaymentAccountEntity?>(
                      bloc: userBalanceCubit,
                      selector: (state) => state.data?.paymentAccount,
                      builder: (context, financialWalletNumber) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              'ID COMPTE: ${financialWalletNumber?.walletNumber ?? '...'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (financialWalletNumber != null) {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: financialWalletNumber.walletNumber,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      LocaleKeys.wallet_module_common_copied
                                          .tr(),
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              Icons.copy,
                              size: 18,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.wallet_module_common_current_balance.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocSelector<UserBalanceCubit,
                        AsyncSnapshot<UserBalanceEntity>, String>(
                      bloc: userBalanceCubit,
                      selector: (state) {
                        if (state.data == null) return '...';
                        return formatCurrency(
                          state.data?.paymentAccount?.userCurrencyBalance ?? 0,
                          state.data?.paymentAccount?.userCurrencyCode ??
                              'FCFA',
                        );
                      },
                      builder: (context, formattedBalance) => Text(
                        formattedBalance,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addFund,
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          LocaleKeys
                              .wallet_module_wallets_page_financier_account_add_funds
                              .tr(),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // En-tête historique
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.wallet_module_common_purchase_history.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: _openHistory,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      LocaleKeys.wallet_module_common_see_all.tr(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_transactions != null && _transactions!.isNotEmpty)
                ..._buildGroupedHistory(_transactions!)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      LocaleKeys.wallet_module_common_no_transaction.tr(),
                      style: const TextStyle(color: Colors.black45),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedHistory(List<FinancialTransactionEntity> items) {
    final now = DateTime.now();
    final today = <FinancialTransactionEntity>[];
    final previous = <FinancialTransactionEntity>[];

    for (final item in items) {
      final isToday = item.createdAt.year == now.year &&
          item.createdAt.month == now.month &&
          item.createdAt.day == now.day;
      (isToday ? today : previous).add(item);
    }

    final widgets = <Widget>[];

    if (today.isNotEmpty) {
      widgets.add(_sectionLabel(LocaleKeys.wallet_module_common_today.tr()));
      widgets.addAll(today.map((e) => TransactionItem(e)));
    }

    if (previous.isNotEmpty) {
      widgets.add(
        _sectionLabel(LocaleKeys.wallet_module_common_previous.tr()),
      );
      widgets.addAll(previous.map((e) => TransactionItem(e)));
    }

    return widgets;
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
          ),
        ],
      ),
    );
  }
}
