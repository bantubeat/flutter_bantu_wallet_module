import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/menetisation_program/featlink_chat_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/menetisation_program/liberty_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/menetisation_program/saloonprived_page.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/menetisation_program/service_pro_page.dart';

import 'restrictions_eligibilite_page.dart';
import 'sanctions_niveaux_page.dart';

class MonetizationHomePage extends StatelessWidget {
  const MonetizationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              const SizedBox(height: 24),
              _buildAboutCard(),
              const SizedBox(height: 32),
              _buildSectionHeader(
                LocaleKeys.wallet_module_monetization_program_how_title.tr(),
                LocaleKeys.wallet_module_monetization_program_how_tag.tr(),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                icon: Icons.card_giftcard_outlined,
                title: LocaleKeys
                    .wallet_module_monetization_program_step1_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_step1_description.tr(),
              ),
              const SizedBox(height: 14),
              _buildStepCard(
                icon: Icons.diamond_outlined,
                title: LocaleKeys
                    .wallet_module_monetization_program_step2_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_step2_description.tr(),
              ),
              const SizedBox(height: 14),
              _buildStepCard(
                icon: Icons.currency_exchange,
                title: LocaleKeys
                    .wallet_module_monetization_program_step3_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_step3_description.tr(),
              ),
              const SizedBox(height: 14),
              _buildStepCard(
                icon: Icons.account_balance_outlined,
                title: LocaleKeys
                    .wallet_module_monetization_program_step4_title.tr(),
                description: LocaleKeys
                    .wallet_module_monetization_program_step4_description.tr(),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(
                LocaleKeys.wallet_module_monetization_program_tools_title.tr(),
                LocaleKeys.wallet_module_monetization_program_tools_tag.tr(),
              ),
              const SizedBox(height: 16),
              _buildToolsGrid(context),
              const SizedBox(height: 28),
              _buildActionTile(
                LocaleKeys.wallet_module_monetization_program_see_restrictions
                    .tr(),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RestrictionsEligibilitePage(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildActionTile(
                LocaleKeys.wallet_module_monetization_program_rules_sanctions
                    .tr(),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SanctionsNiveauxPage(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- APP BAR ----------
  Widget _buildAppBar(BuildContext context) {
    return Row(
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wallet_module_monetization_program_app_title.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                LocaleKeys
                    .wallet_module_monetization_program_app_subtitle.tr(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12),
          ),
          child:
              const Icon(Icons.person_outline, size: 20, color: Colors.black54),
        ),
      ],
    );
  }

  // ---------- À PROPOS CARD ----------
  Widget _buildAboutCard() {
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
          Text(
            LocaleKeys.wallet_module_monetization_program_about.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_monetization_program_about_text1.tr(),
                ),
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_monetization_program_about_diamonds.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_monetization_program_about_text2.tr(),
                ),
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_monetization_program_about_gains.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: LocaleKeys
                      .wallet_module_monetization_program_about_text3.tr(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3F5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 15,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys
                      .wallet_module_monetization_program_secure_certified
                      .tr(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- SECTION HEADER ----------
  Widget _buildSectionHeader(String title, String tag) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        Text(
          tag,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

  // ---------- STEP CARD ----------
  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EAEC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- TOOLS GRID ----------
  Widget _buildToolsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: [
        _buildToolCard(
          color: const Color(0xFFF3D9D6),
          icon: Icons.chat_bubble_outline,
          title: LocaleKeys.wallet_module_monetization_program_chat_title.tr(),
          description: LocaleKeys
              .wallet_module_monetization_program_chat_description.tr(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeatLinkChatPage()),
          ),
        ),
        _buildToolCard(
          color: const Color(0xFFF6E3B4),
          icon: Icons.auto_awesome_outlined,
          title: LocaleKeys
              .wallet_module_monetization_program_saloonprived_title.tr(),
          description: LocaleKeys
              .wallet_module_monetization_program_saloonprived_description
              .tr(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SaloonPrivedPage()),
          ),
        ),
        _buildToolCard(
          color: const Color(0xFFDAD3EF),
          icon: Icons.lock_outline,
          title: LocaleKeys.wallet_module_monetization_program_liberty_title.tr(),
          description: LocaleKeys
              .wallet_module_monetization_program_liberty_description.tr(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LibertyPage()),
          ),
        ),
        _buildToolCard(
          color: const Color(0xFFC9E8D4),
          icon: Icons.work_outline,
          title: LocaleKeys
              .wallet_module_monetization_program_service_pro_title.tr(),
          description: LocaleKeys
              .wallet_module_monetization_program_service_pro_description
              .tr(),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ServiceProPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.black45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- BOTTOM ACTION TILES ----------
  Widget _buildActionTile(String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EAEC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

/// Exemple d'utilisation :
///
/// void main() {
///   runApp(MaterialApp(
///     debugShowCheckedModeBanner: false,
///     home: const MonetizationHomePage(),
///   ));
/// }
