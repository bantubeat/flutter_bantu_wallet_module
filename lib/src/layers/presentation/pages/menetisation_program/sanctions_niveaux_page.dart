import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

import 'widgets/app_colors.dart';
import 'widgets/app_widgets.dart';
import 'demande_levee_restriction_page.dart';

class _SanctionLevel {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final bool severe;

  const _SanctionLevel({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    this.severe = false,
  });
}

class SanctionsNiveauxPage extends StatelessWidget {
  const SanctionsNiveauxPage({super.key});

  static const _levels = [
    _SanctionLevel(
      number: 1,
      title: LocaleKeys.wallet_module_monetization_program_sanction_level1_title,
      description: LocaleKeys
          .wallet_module_monetization_program_sanction_level1_description,
      icon: Icons.info_outline,
    ),
    _SanctionLevel(
      number: 2,
      title:
          LocaleKeys.wallet_module_monetization_program_sanction_level2_title,
      description: LocaleKeys
          .wallet_module_monetization_program_sanction_level2_description,
      icon: Icons.timer,
    ),
    _SanctionLevel(
      number: 3,
      title:
          LocaleKeys.wallet_module_monetization_program_sanction_level3_title,
      description: LocaleKeys
          .wallet_module_monetization_program_sanction_level3_description,
      icon: Icons.flash_off,
    ),
    _SanctionLevel(
      number: 4,
      title:
          LocaleKeys.wallet_module_monetization_program_sanction_level4_title,
      description: LocaleKeys
          .wallet_module_monetization_program_sanction_level4_description,
      icon: Icons.verified_user,
    ),
    _SanctionLevel(
      number: 5,
      title:
          LocaleKeys.wallet_module_monetization_program_sanction_level5_title,
      description: LocaleKeys
          .wallet_module_monetization_program_sanction_level5_description,
      icon: Icons.block,
      severe: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: FeatLinkAppBar(
        title:
            LocaleKeys.wallet_module_monetization_program_sanctions_title.tr(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .wallet_module_monetization_program_sanctions_heading
                        .tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys
                        .wallet_module_monetization_program_sanctions_intro
                        .tr(),
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            for (int i = 0; i < _levels.length; i++)
              _TimelineTile(
                level: _levels[i],
                isLast: i == _levels.length - 1,
              ),
            const SizedBox(height: 12),
            DarkPillButton(
              label: LocaleKeys.wallet_module_monetization_program_request_lift
                  .tr(),
              color: AppColors.textMuted,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DemandeLeveeRestrictionPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final _SanctionLevel level;
  final bool isLast;

  const _TimelineTile({required this.level, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: level.severe ? AppColors.dark : AppColors.cardGreyDark,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${level.number}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: level.severe ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.4, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: level.severe
                      ? const Border(
                          left: BorderSide(color: AppColors.danger, width: 3),
                        )
                      : Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          level.icon,
                          size: 16,
                          color: level.severe
                              ? AppColors.danger
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            level.title.tr(),
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      level.description.tr(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
