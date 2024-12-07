part of '../wallets_page.dart';

class _FinancialAccountBox extends StatelessWidget {
  final bool isAfrican;

  const _FinancialAccountBox({required this.isAfrican});

  void addFund() => Modular.to.pushNamed(WithdrawalPage.pageRoute);

  void requestWithdrawal() => Modular.to.pushNamed(WithdrawalPage.pageRoute);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userBalanceCubit = Modular.get<UserBalanceCubit>();
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      color: Color(0xFFEBEBEB),
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
                      SizedBox(width: 4),
                      /*
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            ' ', // TODO: Add 'ID: 2481525265265525',
                            maxLines: 1,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      ), */
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                BlocSelector<UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>,
                    double?>(
                  bloc: userBalanceCubit,
                  selector: (state) => state.data?.eur,
                  builder: (context, eurBalance) => MySmallButton(
                    backgroundColor: colorScheme.primary,
                    textColor: colorScheme.onPrimary,
                    useFittedBox: true,
                    text: eurBalance == null
                        ? '...'
                        : NumberFormat.currency(
                            symbol: isAfrican ? 'FCFA' : '€',
                          ).format(eurBalance),
                    onTap: userBalanceCubit.fetchUserBalance,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallet_module_wallets_page_financier_account_description
                .tr(),
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          SizedBox(height: 8),
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
