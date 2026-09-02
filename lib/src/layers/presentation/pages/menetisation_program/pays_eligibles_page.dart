import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/layers/data/models/eligible_country.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/repositories/public_repository.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';

import 'widgets/app_colors.dart';
import 'widgets/app_widgets.dart';

class PaysEligiblesPage extends StatefulWidget {
  const PaysEligiblesPage({super.key});

  @override
  State<PaysEligiblesPage> createState() => _PaysEligiblesPageState();
}

class _PaysEligiblesPageState extends State<PaysEligiblesPage> {
  final _searchController = TextEditingController();

  List<EligibleCountry> _countries = [];
  List<EligibleCountry> _filtered = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final countries = await Modular.get<PublicRepository>()
          .checkMonetizationEligibleCountries();
      if (!mounted) return;
      setState(() {
        _countries = countries ?? [];
        _filtered = _countries;
        _isLoading = false;
      });
    } catch (e, st) {
      debugPrint('PaysEligiblesPage._loadCountries error: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _countries
          : _countries
              .where((c) => c.countryCode.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: FeatLinkAppBar(
        title:
            LocaleKeys.wallet_module_monetization_program_eligible_title.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.wallet_module_monetization_program_eligible_intro
                    .tr(),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardGrey,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 14.5),
                  decoration: InputDecoration(
                    hintText: LocaleKeys
                        .wallet_module_monetization_program_search_country
                        .tr(),
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildBody(),
              ),
              const SizedBox(height: 12),
              DarkPillButton(
                label: LocaleKeys.wallet_module_common_close.tr(),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.dark),
      );
    }
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.wallet_module_monetization_program_load_error.tr(),
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadCountries,
              child: Text(
                LocaleKeys.wallet_module_monetization_program_retry.tr(),
              ),
            ),
          ],
        ),
      );
    }
    if (_filtered.isEmpty) {
      return Center(
        child: Text(
          LocaleKeys.wallet_module_monetization_program_no_country_found.tr(),
          style: const TextStyle(color: AppColors.textMuted),
        ),
      );
    }
    return ListView.separated(
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final country = _filtered[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                CountryCode.fromCountryCode(country.countryCode).name ?? '--',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              StatusBadge(
                text:
                    LocaleKeys.wallet_module_monetization_program_available
                        .tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}
