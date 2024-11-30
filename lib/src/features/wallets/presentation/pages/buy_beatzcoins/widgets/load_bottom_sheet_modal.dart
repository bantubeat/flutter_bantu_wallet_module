import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/generated/locale_keys.g.dart';
import '../../../widgets/action_button.dart';
import '../../../widgets/google_icon_svg_image.dart';
import '../../../widgets/squared_bzc_svg_image.dart';

class LoadBottomSheetModal extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LoadBottomSheetModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(height: 4, width: 40, color: Colors.grey[300]),
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys.buy_beatzcoins_page_modal_title.tr(),
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF151515),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.buy_beatzcoins_page_modal_amount_of_your_load.tr(),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Stack(
                        children: [
                          SquaredBzcSvgImage(width: 100),
                          Positioned(
                            top: 5,
                            right: 10,
                            child: Text(
                              510.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        width: double.maxFinite,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF14DF21),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            LocaleKeys.buy_beatzcoins_page_modal_ttc_price.tr(
                              args: [2.25.toString()],
                            ),
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys.buy_beatzcoins_page_modal_buy_with.tr(),
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF151515),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      LocaleKeys.buy_beatzcoins_page_modal_bantubeat_balance
                          .tr(),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          '(ID: ${'1AEH1525N524N525I'.toString()})',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(symbol: '€').format(25498),
                  style: TextStyle(
                    fontSize: 20,
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ActionButton(
            onPressed: () {},
            fullWidth: true,
            prefixIcon: Icon(Icons.apple, color: Colors.black, size: 28),
            text: 'Pay',
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          SizedBox(height: 20),
          ActionButton(
            onPressed: () {},
            fullWidth: true,
            prefixIcon: GoogleIconSvgImage(width: 20),
            text: ' Pay',
            backgroundColor: Colors.white,
            textColor: Colors.black,
          ),
          SizedBox(height: 20),
          Text(
            LocaleKeys.buy_beatzcoins_page_modal_warning1.tr(),
            style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: LocaleKeys.buy_beatzcoins_page_modal_warning2a.tr(),
              style: TextStyle(fontSize: 12, color: Color(0xFF181818)),
              children: [
                TextSpan(
                  text: LocaleKeys.buy_beatzcoins_page_modal_warning2b.tr(),
                  style: TextStyle(fontSize: 12, color: colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
