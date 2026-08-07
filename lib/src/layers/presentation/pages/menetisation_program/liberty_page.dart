import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'widgets/monetization_widgets.dart';

class LibertyPage extends StatelessWidget {
  const LibertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    borderRadius: BorderRadius.circular(24),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.wallet_module_monetization_program_liberty_title
                        .tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kTextDark,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                LocaleKeys.wallet_module_monetization_program_tools_monetization
                    .tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kTextDark,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 18),
              // Carte "Cadeaux" avec watermark cadeau en fond
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        Icons.card_giftcard,
                        size: 90,
                        color: Colors.black.withValues(alpha: 0.04),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys
                                .wallet_module_monetization_program_gifts.tr(),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: kTextDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            LocaleKeys
                                .wallet_module_monetization_program_liberty_gifts_description
                                .tr(),
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Bandeau info
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: kCardGrey,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.black45),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        LocaleKeys
                            .wallet_module_monetization_program_more_tools_soon
                            .tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
