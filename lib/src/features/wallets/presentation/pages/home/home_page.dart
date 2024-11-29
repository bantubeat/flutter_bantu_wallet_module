import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/generated/locale_keys.g.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../wallet_module.dart';
import '../beatzcoins/beatzcoins_page.dart';
import '../deposit/deposit_page.dart';
import '../transactions_history/transactions_history_page.dart';
import '../wallets/wallets_page.dart';
import '../withdrawal/withdrawal_page.dart';
import 'widgets/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const pageRoute = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Center(
                child: Text(
                  LocaleKeys.home_page_title.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MenuItem(
                icon: Icons.account_balance_wallet,
                title: LocaleKeys.home_page_wallet.tr(),
                onTap: () => Modular.to.pushNamed(WalletsPage.pageRoute),
              ),
              const SizedBox(height: 20),
              MenuItem(
                icon: Icons.account_balance_wallet,
                title: LocaleKeys.home_page_deposit.tr(),
                onTap: () => Modular.to.pushNamed(DepositPage.pageRoute),
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Icons.money,
                title: LocaleKeys.home_page_withdrawal.tr(),
                onTap: () => Modular.to.pushNamed(WithdrawalPage.pageRoute),
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Icons.currency_bitcoin,
                title: LocaleKeys.home_page_beatzcoins.tr(),
                onTap: () => Modular.to.pushNamed(BeatzcoinsPage.pageRoute),
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Icons.history,
                title: LocaleKeys.home_page_transactions_history.tr(),
                onTap: () =>
                    Modular.to.pushNamed(TransactionsHistoryPage.pageRoute),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: WalletModule.getFloatingMenuWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
