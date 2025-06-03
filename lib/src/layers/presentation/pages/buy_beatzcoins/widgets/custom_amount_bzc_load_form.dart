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
  BzcCurrencyConverter? _bzcCurrencyConverter;

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
    final amountInBzc = num.tryParse(bzcTextCtrl.text)?.toDouble();
    final converter = _bzcCurrencyConverter;

    if (converter != null && amountInBzc != null && amountInBzc > 0) {
      setState(() {
        fiatAmount = widget.isAfrican
            ? converter.bzcToXaf(amountInBzc, applyFees: false)
            : converter.bzcToEur(amountInBzc, applyFees: false);
      });
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
    if (bzcQuantity == null || bzcQuantity < 30) return;
    LoadBottomSheetModal.show(
      context,
      isAfrican: widget.isAfrican,
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
                        decimalDigits: 4,
                      ).format(fiatAmount),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ActionButton(
            fullWidth: true,
            onPressed: onExchange,
            enabled: (bzcQuantity ?? 0) >= 30,
            text: LocaleKeys.wallet_module_buy_beatzcoins_page_load.tr(),
          ),
        ],
      ),
    );
  }
}
