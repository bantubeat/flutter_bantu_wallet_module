part of '../balance_page.dart';

class _FinancialAccountBox extends StatelessWidget {
  final bool isAfrican;

  const _FinancialAccountBox({required this.isAfrican});

  void addFund() => Modular.get<WalletRoutes>().deposit.push();

  void requestWithdrawal() => Modular.get<WalletRoutes>().withdrawal.push();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userBalanceCubit = Modular.get<UserBalanceCubit>();
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys
                            .wallet_module_wallets_page_financier_account_title
                            .tr(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      BlocSelector<UserBalanceCubit,
                          AsyncSnapshot<UserBalanceEntity>, String?>(
                        bloc: userBalanceCubit,
                        selector: (state) => state.data?.financialWalletNumber,
                        builder: (context, financialWalletNumber) => Expanded(
                          child: FittedBox(
                            child: Text(
                              "ID: ${financialWalletNumber ?? '...'}",
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                BlocSelector<UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>,
                    String>(
                  bloc: userBalanceCubit,
                  selector: (state) {
                    if (state.data == null) return '...';
                    return NumberFormat.currency(
                      locale: isAfrican ? 'fr_CM' : 'fr_FR',
                      name: isAfrican ? 'XAF' : 'EUR',
                      symbol: isAfrican ? 'FCFA' : '€',
                    ).format(isAfrican ? state.data?.xaf : state.data?.eur);
                  },
                  builder: (context, formattedBalance) => MySmallButton(
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    useFittedBox: true,
                    text: formattedBalance,
                    onTap: userBalanceCubit.fetchUserBalance,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.wallet_module_wallets_page_financier_account_description
                .tr(),
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MySmallButton(
                backgroundColor: colorScheme.onSurface,
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: LocaleKeys
                    .wallet_module_wallets_page_financier_account_request_payment
                    .tr(),
                onTap: requestWithdrawal,
              ),
              MySmallButton(
                backgroundColor: colorScheme.onSurface.withAlpha(200),
                textColor: colorScheme.onPrimary,
                useFittedBox: true,
                text: LocaleKeys
                    .wallet_module_wallets_page_financier_account_add_funds
                    .tr(),
                onTap: addFund,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
