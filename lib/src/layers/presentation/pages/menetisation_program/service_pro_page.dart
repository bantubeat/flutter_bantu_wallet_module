import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/api_constants.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'widgets/monetization_widgets.dart';

class ServiceProPage extends StatelessWidget {
  const ServiceProPage({super.key});

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
                title: LocaleKeys
                    .wallet_module_monetization_program_services_pro.tr(),
                subtitle: '',
              ),
              const SizedBox(height: 24),
              Pill(
                label: LocaleKeys
                    .wallet_module_monetization_program_profil_pro_required
                    .tr(),
                bg: kCardGrey,
                textColor: Colors.black54,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_service_pro_label.tr(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_monetize_expertise
                    .tr(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 22),
              _ServiceCard(
                icon: Icons.ondemand_video_outlined,
                locked: true,
                title: LocaleKeys
                    .wallet_module_monetization_program_content_sale.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_subscriptions_access_ppv
                    .tr(),
                footnote: LocaleKeys
                    .wallet_module_monetization_program_receive_gains_when_fans_buy
                    .tr(),
              ),
              const SizedBox(height: 14),
              _ServiceCard(
                icon: Icons.shopping_bag_outlined,
                locked: false,
                title: LocaleKeys
                    .wallet_module_monetization_program_items_sale.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_items_sale_description
                    .tr(),
              ),
              const SizedBox(height: 14),
              _ServiceCard(
                icon: Icons.card_giftcard_outlined,
                locked: false,
                title:
                    LocaleKeys.wallet_module_monetization_program_gifts.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_gifts_conversation_description
                    .tr(),
              ),
              const SizedBox(height: 20),
              // Bandeau image bas de page
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFDADCE0), Color(0xFFB9BCC2)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Image.asset(
                          ApiConstants.servicesProBg,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.15),
                        ),
                        child: Text(
                          LocaleKeys
                              .wallet_module_monetization_program_banner_text
                              .tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
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

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final bool locked;
  final String title;
  final String description;
  final String? footnote;

  const _ServiceCard({
    required this.icon,
    required this.locked,
    required this.title,
    required this.description,
    this.footnote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIcon(icon: icon),
              Pill(
                label:
                    LocaleKeys.wallet_module_monetization_program_diamonds.tr(),
                bg: kPink,
                textColor: kPinkText,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (locked) ...[
                const Icon(Icons.lock, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFECECEC)),
            const SizedBox(height: 12),
            Text(
              footnote!,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: Colors.black45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
