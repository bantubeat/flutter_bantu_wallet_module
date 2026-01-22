import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/generated/locale_keys.g.dart';

import '../../navigation/wallet_routes.dart';
import '../../wallet_module.dart';
import 'widgets/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              const Align(
                alignment: AlignmentGeometry.centerLeft,
                child: IconButton(
                  onPressed: WalletModule.handleCloseModule,
                  icon: Icon(Icons.close, size: 30),
                ),
              ),
              Center(
                child: Text(
                  LocaleKeys.wallet_module_home_page_title.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MenuItem(
                icon: Icons.account_balance_wallet,
                title: LocaleKeys.wallet_module_home_page_wallet.tr(),
                onTap: Modular.get<WalletRoutes>().balance.push,
              ),
              const SizedBox(height: 20),
              MenuItem(
                icon: Icons.account_balance_wallet,
                title: LocaleKeys.wallet_module_home_page_deposit.tr(),
                onTap: Modular.get<WalletRoutes>().deposit.push,
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Icons.money,
                title: LocaleKeys.wallet_module_home_page_withdrawal.tr(),
                onTap: Modular.get<WalletRoutes>().withdrawal.push,
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Feather.database,
                title: LocaleKeys.wallet_module_home_page_beatzcoins.tr(),
                onTap: Modular.get<WalletRoutes>().beatzcoins.push,
              ),
              const SizedBox(height: 10),
              MenuItem(
                icon: Icons.history,
                title: LocaleKeys.wallet_module_home_page_transactions_history
                    .tr(),
                onTap: Modular.get<WalletRoutes>().transactions.push,
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
