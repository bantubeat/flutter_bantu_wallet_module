import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_balance_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/generated/locale_keys.g.dart';
import 'widgets/menu_tile.dart';

class FeatlinkWalletPage extends StatelessWidget {
  const FeatlinkWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chips = [
      ChipData(
        LocaleKeys.wallet_module_featlink_home_page_sales.tr(),
        const Color(0xFF6B6B6B),
      ),
      ChipData(
        LocaleKeys.wallet_module_featlink_home_page_tips.tr(),
        const Color(0xFF9B6B9B),
      ),
      ChipData(
        LocaleKeys.wallet_module_featlink_home_page_gifts.tr(),
        const Color(0xFF6BA3D6),
      ),
    ];

    final userBalanceCubit = Modular.get<UserBalanceCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: const InkWell(
          onTap: WalletModule.handleCloseModule,
          child: Icon(Icons.arrow_back, color: Colors.black),
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
        onRefresh: userBalanceCubit.fetchUserBalance,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                LocaleKeys.wallet_module_featlink_home_page_subtitle.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
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
                    Text(
                      LocaleKeys
                          .wallet_module_featlink_home_page_estimated_revenue
                          .tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    BlocSelector<UserBalanceCubit,
                        AsyncSnapshot<UserBalanceEntity>, String?>(
                      bloc: userBalanceCubit,
                      selector: (state) =>
                          state.data?.revenueAccount?.walletNumber,
                      builder: (context, financialWalletNumber) => Text(
                        "ID: ${financialWalletNumber ?? '...'}",
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8E8ED9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocSelector<UserBalanceCubit,
                        AsyncSnapshot<UserBalanceEntity>, String>(
                      bloc: userBalanceCubit,
                      selector: (state) {
                        if (state.data == null) return '...';
                        return formatCurrency(
                          state.data?.revenueAccount?.userCurrencyBalance ?? 0,
                          state.data?.revenueAccount?.userCurrencyCode ??
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final chip = chips[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: chip.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chip.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.wallet_module_featlink_home_page_earn_with_featlink
                    .tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  EarnCard(
                    color: const Color(0xFFFBE0A8),
                    icon: Icons.auto_awesome,
                    title: 'SaloonPrived',
                    subtitle: LocaleKeys
                        .wallet_module_featlink_home_page_saloonprived_description
                        .tr(),
                  ),
                  EarnCard(
                    color: const Color(0xFFF7CFCF),
                    icon: Icons.chat_bubble_outline,
                    title: 'Featlink Chat',
                    subtitle: LocaleKeys
                        .wallet_module_featlink_home_page_chat_description
                        .tr(),
                  ),
                  EarnCard(
                    color: const Color(0xFFDCD3F5),
                    icon: Icons.lock_outline,
                    title: 'Liberty',
                    subtitle: LocaleKeys
                        .wallet_module_featlink_home_page_liberty_description
                        .tr(),
                  ),
                  EarnCard(
                    color: const Color(0xFFB9E8C9),
                    icon: Icons.work_outline,
                    title: 'Service Pro',
                    subtitle: LocaleKeys
                        .wallet_module_featlink_home_page_servicepro_description
                        .tr(),
                  ),
                ],
              ),
              // const SizedBox(height: 15),
              MenuTile(
                onPress: Modular.get<WalletRoutes>().balance.push,
                icon: Icons.receipt_long_outlined,
                title: LocaleKeys.wallet_module_featlink_home_page_menu_billing
                    .tr(),
                subtitle: LocaleKeys
                    .wallet_module_featlink_home_page_menu_billing_description
                    .tr(),
              ),
              const SizedBox(height: 12),
              MenuTile(
                onPress: Modular.get<WalletRoutes>().withdrawal.push,
                icon: Icons.attach_money,
                title: LocaleKeys
                    .wallet_module_featlink_home_page_menu_monetization
                    .tr(),
                subtitle: LocaleKeys
                    .wallet_module_featlink_home_page_menu_monetization_description
                    .tr(),
              ),
              const SizedBox(height: 12),
              MenuTile(
                onPress: Modular.get<WalletRoutes>().beatzcoins.push,
                icon: null,
                customIconLabel: 'BZC',
                title: 'Beatzcoins',
                subtitle: LocaleKeys
                    .wallet_module_featlink_home_page_menu_beatzcoins_description
                    .tr(),
              ),
              const SizedBox(height: 12),
              MenuTile(
                onPress: Modular.get<WalletRoutes>().transactions.push,
                icon: Icons.history,
                title: LocaleKeys.wallet_module_featlink_home_page_menu_history
                    .tr(),
                subtitle: LocaleKeys
                    .wallet_module_featlink_home_page_menu_history_description
                    .tr(),
              ),
              const SizedBox(height: 28),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  icon: const Icon(Icons.help_outline, color: Colors.black),
                  label: Text(
                    LocaleKeys.wallet_module_featlink_home_page_help_center
                        .tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
}
