import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'widgets/monetization_widgets.dart';

class FeatLinkChatPage extends StatelessWidget {
  const FeatLinkChatPage({super.key});

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
                    LocaleKeys.wallet_module_monetization_program_chat_title
                        .tr(),
                subtitle: LocaleKeys
                    .wallet_module_monetization_program_chat_monetize.tr(),
              ),
              const SizedBox(height: 26),
              Text(
                LocaleKeys.wallet_module_monetization_program_chat_hero.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: kTextDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                LocaleKeys.wallet_module_monetization_program_chat_intro.tr(),
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 22),
              _ChatToolCard(
                icon: Icons.chat_bubble_outline,
                iconBg: kCardGrey,
                iconColor: Colors.black87,
                statusLabel:
                    LocaleKeys.wallet_module_monetization_program_active.tr(),
                statusBg: kTextDark,
                statusColor: Colors.white,
                title:
                    LocaleKeys.wallet_module_monetization_program_dialpay_title
                        .tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_dialpay_description
                    .tr(),
                italicNote: LocaleKeys
                    .wallet_module_monetization_program_dialpay_note.tr(),
              ),
              const SizedBox(height: 14),
              _ChatToolCard(
                icon: Icons.favorite,
                iconBg: const Color(0xFFF3D9D6),
                iconColor: const Color(0xFFB0394F),
                statusLabel: LocaleKeys
                    .wallet_module_monetization_program_standard.tr(),
                statusBg: kCardGrey,
                statusColor: Colors.black54,
                title:
                    LocaleKeys.wallet_module_monetization_program_swippay_title
                        .tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_swippay_description
                    .tr(),
                italicNote: LocaleKeys
                    .wallet_module_monetization_program_swippay_note.tr(),
              ),
              const SizedBox(height: 14),
              _ChatToolCard(
                icon: Icons.card_giftcard,
                iconBg: kCardGrey,
                iconColor: Colors.black87,
                statusLabel: LocaleKeys
                    .wallet_module_monetization_program_unlimited.tr(),
                statusBg: kCardGrey,
                statusColor: Colors.black54,
                title:
                    LocaleKeys.wallet_module_monetization_program_gifts.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_gifts_chat_description
                    .tr(),
                italicNote: LocaleKeys
                    .wallet_module_monetization_program_gifts_note.tr(),
              ),
              const SizedBox(height: 34),
              Center(
                child: Column(
                  children: [
                    Text(
                      LocaleKeys
                          .wallet_module_monetization_program_engine_label
                          .tr(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      LocaleKeys
                          .wallet_module_monetization_program_secure_compliant
                          .tr(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatToolCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String statusLabel;
  final Color statusBg;
  final Color statusColor;
  final String title;
  final String description;
  final String italicNote;

  const _ChatToolCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.statusLabel,
    required this.statusBg,
    required this.statusColor,
    required this.title,
    required this.description,
    required this.italicNote,
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
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              Pill(label: statusLabel, bg: statusBg, textColor: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
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
          const Divider(height: 1, color: Color(0xFFECECEC)),
          const SizedBox(height: 12),
          Text(
            italicNote,
            style: TextStyle(
              fontSize: 12.5,
              fontStyle: FontStyle.italic,
              height: 1.4,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.diamond_outlined, size: 13, color: Colors.black45),
              const SizedBox(width: 6),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_reward_diamonds.tr(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
