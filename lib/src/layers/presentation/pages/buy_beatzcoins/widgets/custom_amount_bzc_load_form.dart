part of '../buy_beatzcoins_page.dart';

class _CustomAmountBzcLoadForm extends StatefulWidget {
  final bool isAfrican;

  const _CustomAmountBzcLoadForm({required this.isAfrican});

  @override
  State<StatefulWidget> createState() => _CustomAmountBzcLoadFormState();
}

class _CustomAmountBzcLoadFormState extends State<_CustomAmountBzcLoadForm> {
  final bzcTextCtrl = TextEditingController();
  double? fiatAmount;
  TokenPriceEntity? _tokenPrice;

  String get fiatCurrencySymbol =>
      _tokenPrice?.symbol ?? (widget.isAfrican ? 'F CFA' : '€');

  bool get converterInitialized => _tokenPrice != null;

  @override
  void initState() {
    super.initState();
    bzcTextCtrl.addListener(_performCalculation);
    Modular.get<GetTokenPricesUseCase>()
        .call(NoParms())
        .then((tokenPrice) => setState(() => _tokenPrice = tokenPrice));
  }

  void _performCalculation() {
    final amountInBzc = num.tryParse(bzcTextCtrl.text)?.toDouble();
    final unitPrice = _tokenPrice?.unitPrice;

    if (unitPrice != null && amountInBzc != null && amountInBzc > 0) {
      setState(() => fiatAmount = amountInBzc * unitPrice);
    } else {
      setState(() => fiatAmount = null);
    }
  }

  @override
  void dispose() {
    bzcTextCtrl.dispose();
    super.dispose();
  }

  void onExchange() {
    final bzcQuantity = num.tryParse(bzcTextCtrl.text)?.toDouble();
    final tokenPrice = _tokenPrice;
    if (bzcQuantity == null || bzcQuantity < 30 || tokenPrice == null) return;
    LoadBottomSheetModal.show(
      context,
      isAfrican: widget.isAfrican,
      tokenPrice: tokenPrice,
      bzcQuantity: bzcQuantity,
    ).whenComplete(bzcTextCtrl.clear);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bzcQuantity = num.tryParse(bzcTextCtrl.text)?.toDouble();
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(width: 1, color: Colors.grey.shade300),
        boxShadow: kElevationToShadow[1],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.wallet_module_buy_beatzcoins_page_custom_load.tr(),
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: bzcTextCtrl,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: LocaleKeys
                  .wallet_module_buy_beatzcoins_page_enter_quantity
                  .tr(),
              filled: true,
              fillColor: const Color(0xFFEBEBEB),
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Color(0xFFA5A5A5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(6),
              ),
              errorText: (bzcQuantity ?? 0) > 0 && (bzcQuantity ?? 0) < 30
                  ? LocaleKeys.wallet_module_buy_beatzcoins_page_min_fiat_amount
                      .tr(namedArgs: {'amount': 30.toString()})
                  : '',
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.wallet_module_buy_beatzcoins_page_ttc_amount_in.tr(
                  namedArgs: {'amount': widget.isAfrican ? 'F CFA' : '€'},
                ),
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                fiatAmount == null
                    ? '...'
                    : NumberFormat.currency(
                        symbol: fiatCurrencySymbol,
                        decimalDigits: 2,
                      ).format(fiatAmount),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ActionButton(
            fullWidth: true,
            backgroundColor: Colors.black,
            onPressed: onExchange,
            enabled: (bzcQuantity ?? 0) >= 30,
            text: LocaleKeys.wallet_module_buy_beatzcoins_page_load.tr(),
          ),
        ],
      ),
    );
  }
}
