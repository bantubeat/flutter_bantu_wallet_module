part of '../balance_page.dart';

class _BeatzacoinAccountBox extends StatefulWidget {
  final bool isAfrican;

  const _BeatzacoinAccountBox({required this.isAfrican});

  @override
  State<_BeatzacoinAccountBox> createState() => _BeatzacoinAccountBoxState();
}

class _BeatzacoinAccountBoxState extends State<_BeatzacoinAccountBox> {
  final userBalanceCubit = Modular.get<UserBalanceCubit>();
  static const minimumBzc = 500;

  final bzcTextCtrl = TextEditingController();
  final fiatTextCtrl = TextEditingController();
  BzcCurrencyConverter? _bzcCurrencyConverter;

  bool isExchanging = false;

  String get fiatCurrencySymbol => widget.isAfrican ? 'F CFA' : '€';

  bool get converterInitialized => _bzcCurrencyConverter != null;

  @override
  void initState() {
    super.initState();
    bzcTextCtrl.addListener(_performConversion);
    Modular.get<GetBzcCurrencyConverterUseCase>()
        .call(NoParms())
        .then((converter) => setState(() => _bzcCurrencyConverter = converter));
  }

  void _performConversion() {
    fiatTextCtrl.text = '...';
    final converter = _bzcCurrencyConverter;

    if (converter == null || bzcTextCtrl.text.isEmpty) {
      setState(() {});
      return;
    }

    final amountInBzc = num.tryParse(bzcTextCtrl.text)?.toDouble();
    if (amountInBzc == null || amountInBzc < minimumBzc) {
      setState(() {});
      return;
    }

    final fiatAmount = widget.isAfrican
        ? converter.bzcToXaf(amountInBzc, applyFees: true)
        : converter.bzcToEur(amountInBzc, applyFees: true);

    fiatTextCtrl.text = NumberFormat.currency(
      symbol: fiatCurrencySymbol,
    ).format(fiatAmount);

    setState(() {});
  }

  @override
  void dispose() {
    bzcTextCtrl.dispose();
    fiatTextCtrl.dispose();
    super.dispose();
  }

  bool _canExchange() {
    final bzcQuantity = num.tryParse(bzcTextCtrl.text)?.toDouble();
    final yourCurrentBZC = userBalanceCubit.state.data?.bzc;
    return (bzcQuantity != null &&
        yourCurrentBZC != null &&
        bzcQuantity >= minimumBzc &&
        bzcQuantity < yourCurrentBZC);
  }

  void _onExchange() async {
    final bzcQuantity = num.tryParse(bzcTextCtrl.text)?.toDouble();
    if (bzcQuantity == null || bzcQuantity < minimumBzc) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_wallets_page_beatzcoin_account_minimum_bzc.tr(
          namedArgs: {'min_quantity': minimumBzc.toString()},
        ),
      );
      return;
    }

    try {
      setState(() => isExchanging = true);
      await Modular.get<ExchangeBzcToFiatUseCase>().call(
        (quantity: bzcQuantity),
      );

      if (!mounted) return;
      UiAlertHelpers.showSuccessSnackBar(
        context,
        LocaleKeys
            .wallet_module_wallets_page_beatzcoin_account_exchange_successful
            .tr(),
      );
      bzcTextCtrl.clear();
      fiatTextCtrl.clear();
      userBalanceCubit.fetchUserBalance();
    } catch (e) {
      if (!mounted) return;
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.wallet_module_common_an_error_occur.tr(
          namedArgs: {
            'message':
                ((e is MyHttpException) ? e.message : null) ?? e.toString(),
          },
        ),
      );
    } finally {
      setState(() => isExchanging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(5),
      color: const Color(0xFFEBEBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      LocaleKeys
                          .wallet_module_wallets_page_beatzcoin_account_title
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
                      selector: (state) => state.data?.beatzcoinWalletNumber,
                      builder: (context, beatzcoinWalletNumber) => Expanded(
                        child: FittedBox(
                          child: Text(
                            "ID: ${beatzcoinWalletNumber ?? '...'}",
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
                  double?>(
                bloc: userBalanceCubit,
                selector: (state) => state.data?.bzc,
                builder: (context, bzcBalance) => MySmallButton(
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onPrimary,
                  useFittedBox: true,
                  text: bzcBalance == null
                      ? '...'
                      : NumberFormat.currency(symbol: 'BZC').format(
                          bzcBalance,
                        ),
                  onTap: userBalanceCubit.fetchUserBalance,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.wallet_module_wallets_page_beatzcoin_account_description1
                .tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.wallet_module_wallets_page_beatzcoin_account_description2
                .tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: LocaleKeys
                  .wallet_module_wallets_page_beatzcoin_account_description3
                  .tr(),
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_wallets_page_beatzcoin_account_description4
                      .tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlString(
                        'https://legal.bantubeat.com/bantubeat/help-center?index=7',
                      );
                    },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: bzcTextCtrl,
                      enabled: converterInitialized,
                      style: TextStyle(color: colorScheme.onSurface),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: converterInitialized
                            ? 'BZC'
                            : LocaleKeys.wallet_module_common_initializing.tr(),
                        errorText: LocaleKeys
                            .wallet_module_wallets_page_beatzcoin_account_minimum_bzc
                            .tr(
                          namedArgs: {'min_quantity': minimumBzc.toString()},
                        ),
                        fillColor: const Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: const EdgeInsets.all(5),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: fiatTextCtrl,
                      readOnly: true,
                      enabled: false,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: converterInitialized
                            ? fiatCurrencySymbol
                            : LocaleKeys.wallet_module_common_initializing.tr(),
                        errorText: '',
                        fillColor: const Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: const EdgeInsets.all(5),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: converterInitialized,
            child: Visibility(
              visible: !isExchanging,
              replacement:
                  const Center(child: CircularProgressIndicator.adaptive()),
              child: Visibility(
                visible: _canExchange(),
                child: InkWell(
                  onTap: _onExchange,
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      converterInitialized
                          ? LocaleKeys
                              .wallet_module_wallets_page_beatzcoin_account_exchange
                              .tr()
                          : LocaleKeys.wallet_module_common_initializing.tr(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
