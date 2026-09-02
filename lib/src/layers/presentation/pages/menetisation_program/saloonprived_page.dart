import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/api_constants.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'widgets/monetization_widgets.dart';

class SaloonPrivedPage extends StatelessWidget {
  const SaloonPrivedPage({super.key});

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
              ToolAppBar(
                title:
                    LocaleKeys.wallet_module_monetization_program_saloonprived
                        .tr(),
                subtitle: LocaleKeys
                    .wallet_module_monetization_program_saloonprived_monetize
                    .tr(),
              ),
              const SizedBox(height: 26),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_saloonprived_label
                    .tr(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocaleKeys.wallet_module_monetization_program_tools_monetization
                    .tr(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: kTextDark,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 18),

              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 210,
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    ApiConstants.saloondprivedBg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Carte principale : vente de contenu exclusif
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock, size: 17, color: Colors.black87),
                        const SizedBox(width: 8),
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_exclusive_content_sale
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kTextDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      LocaleKeys
                          .wallet_module_monetization_program_subscriptions_access_ppv
                          .tr(),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.black.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFECECEC)),
                    const SizedBox(height: 12),
                    Text(
                      LocaleKeys
                          .wallet_module_monetization_program_receive_gains_when_fans_buy
                          .tr(),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _AccentCard(
                icon: Icons.volunteer_activism_outlined,
                title: LocaleKeys.wallet_module_monetization_program_tips.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_receive_tips.tr(),
              ),
              const SizedBox(height: 14),
              _AccentCard(
                icon: Icons.card_giftcard_outlined,
                title: LocaleKeys.wallet_module_monetization_program_gifts.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_receive_gifts.tr(),
              ),
              const SizedBox(height: 30),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_good_practices.tr(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFDCDDE0)),
              const SizedBox(height: 18),
              _PracticeStep(
                number: '1',
                title: LocaleKeys
                    .wallet_module_monetization_program_practice1_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_practice1_description
                    .tr(),
              ),
              const SizedBox(height: 18),
              _PracticeStep(
                number: '2',
                title: LocaleKeys
                    .wallet_module_monetization_program_practice2_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_practice2_description
                    .tr(),
              ),
              const SizedBox(height: 26),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: kCardGrey,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Text(
                  LocaleKeys
                      .wallet_module_monetization_program_creator_guide.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AccentCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: const Border(
                  left: BorderSide(color: Colors.black87, width: 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleIcon(icon: icon),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Pill(
                    label: LocaleKeys
                        .wallet_module_monetization_program_reward_diamonds
                        .tr(),
                    bg: kCardGrey,
                    textColor: Colors.black54,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _PracticeStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: kTextDark,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
