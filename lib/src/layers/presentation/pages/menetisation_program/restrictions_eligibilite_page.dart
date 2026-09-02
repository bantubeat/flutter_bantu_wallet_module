import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

import 'widgets/app_colors.dart';
import 'widgets/app_widgets.dart';
import 'pays_eligibles_page.dart';
import 'sanctions_niveaux_page.dart';

class RestrictionsEligibilitePage extends StatelessWidget {
  const RestrictionsEligibilitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: FeatLinkAppBar(
        title: LocaleKeys
            .wallet_module_monetization_program_restrictions_title
            .tr(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              LocaleKeys
                  .wallet_module_monetization_program_restrictions_heading.tr(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              LocaleKeys.wallet_module_monetization_program_safety_center.tr(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),

            // Pays non éligible
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_country_not_eligible
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_country_not_eligible_description
                              .tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PaysEligiblesPage(),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.cardGrey,
                            side: BorderSide.none,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            LocaleKeys
                                .wallet_module_monetization_program_see_eligible_countries
                                .tr(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.cardGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.public,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Violation des politiques
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.gavel,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_policy_violation
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_policy_violation_description
                              .tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contenu non conforme
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  left: BorderSide(color: AppColors.dark, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.block,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_non_compliant_content
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LocaleKeys
                              .wallet_module_monetization_program_non_compliant_content_description
                              .tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            DarkPillButton(
              label: LocaleKeys
                  .wallet_module_monetization_program_understand_sanctions
                  .tr(),
              trailingIcon: Icons.arrow_forward,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SanctionsNiveauxPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
