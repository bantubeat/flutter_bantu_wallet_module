part of '../wallets_page.dart';

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

  String get fiatCurrencySymbol => widget.isAfrican ? 'CFA' : '€';

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

    if (converter == null || bzcTextCtrl.text.isEmpty) return;

    final amountInBzc = num.tryParse(bzcTextCtrl.text)?.toDouble();
    if (amountInBzc == null || amountInBzc < minimumBzc) return;

    final fiatAmount = widget.isAfrican
        ? converter.bzcToEur(amountInBzc)
        : converter.bzcToEur(amountInBzc);

    fiatTextCtrl.text = NumberFormat.currency(
      symbol: fiatCurrencySymbol,
    ).format(fiatAmount);
  }

  @override
  void dispose() {
    bzcTextCtrl.dispose();
    fiatTextCtrl.dispose();
    super.dispose();
  }

  void _onExchange() async {
    final bzcQuantity = num.tryParse(bzcTextCtrl.text)?.toDouble();
    if (bzcQuantity == null || bzcQuantity < minimumBzc) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallets_page_beatzcoin_account_minimum_bzc.tr(
          args: [minimumBzc.toString()],
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
        LocaleKeys.wallets_page_beatzcoin_account_exchange_successful.tr(),
      );
      bzcTextCtrl.clear();
      fiatTextCtrl.clear();
      userBalanceCubit.fetchUserBalance();
    } catch (e) {
      if (!mounted) return;
      UiAlertHelpers.showErrorSnackBar(
        context,
        LocaleKeys.common_an_error_occur.tr(
          args: [((e is MyHttpException) ? e.message : null) ?? e.toString()],
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
      color: Color(0xFFEBEBEB),
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
                      LocaleKeys.wallets_page_beatzcoin_account_title.tr(),
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
                          '', // TODO: Add 'ID: 2481525265265525',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
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
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallets_page_beatzcoin_account_description1.tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.wallets_page_beatzcoin_account_description2.tr(),
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: LocaleKeys.wallets_page_beatzcoin_account_description3.tr(),
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys.wallets_page_beatzcoin_account_description4
                      .tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
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
                            : LocaleKeys.common_initializing.tr(),
                        errorText: LocaleKeys
                            .wallets_page_beatzcoin_account_minimum_bzc
                            .tr(
                          args: [minimumBzc.toString()],
                        ),
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(5),
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
                    height: 45,
                    child: TextField(
                      controller: fiatTextCtrl,
                      readOnly: true,
                      enabled: false,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: converterInitialized
                            ? fiatCurrencySymbol
                            : LocaleKeys.common_initializing.tr(),
                        errorText: '',
                        fillColor: Color(0xFFD9D9D9),
                        filled: true,
                        contentPadding: EdgeInsets.all(5),
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
          SizedBox(height: 10),
          Visibility(
            visible: converterInitialized,
            child: Visibility(
              visible: !isExchanging,
              replacement: Center(child: CircularProgressIndicator.adaptive()),
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
                        ? LocaleKeys.wallets_page_beatzcoin_account_exchange
                            .tr()
                        : LocaleKeys.common_initializing.tr(),
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
        ],
      ),
    );
  }
}
