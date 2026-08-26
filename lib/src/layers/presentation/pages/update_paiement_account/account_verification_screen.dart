import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/navigation/wallet_routes.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'edit_payment_account_screen.dart';

class AccountVerificationScreen extends StatefulWidget {
  const AccountVerificationScreen(this.paymentPreferenceEntity, {super.key});
  final PaymentPreferenceEntity paymentPreferenceEntity;
  @override
  State<AccountVerificationScreen> createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  final _ibanController = TextEditingController();
  final _mobileController = TextEditingController();

  final bool _ibanLocked = false;
  final bool _mobileLocked = false;

  String? _ibanError;
  String? _mobileError;

  /// null = chargement en cours ; true = un moyen de paiement existe déjà
  /// pour ce type de compte ; false = aucun moyen pour ce type.
  bool? _hasPaymentMethod;
  List<PaymentPreferenceEntity> preferencesList = [];
  static const _borderColor = Color(0xFFDDDDDD);
  static const _lockedBg = Color(0xFFECECEC);
  static const _lockedText = Color(0xFFB3B3B3);
  static const _errorColor = Color(0xFFE53935);
  static const _buttonColor = Color(0xFF141414);

  @override
  void initState() {
    super.initState();
    _loadPaymentMethodStatus();
  }

  Future<void> _loadPaymentMethodStatus() async {
    final type = widget.paymentPreferenceEntity.accountType;
    try {
      final preferences =
          await Modular.get<GetPaymentPreferencesUseCase>().call(NoParms());
      if (!mounted) return;
      setState(() {
        preferencesList = preferences;
        _hasPaymentMethod = preferences.any((p) => p.accountType == type);
      });
    } catch (err) {
      debugPrint('[AccountVerificationScreen] payment preferences error: $err');
      if (!mounted) return;
      setState(() => _hasPaymentMethod = false);
    }
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _submitIban() async {
    if (_ibanController.text.trim().isEmpty) {
      setState(() {
        _ibanError = LocaleKeys.wallet_module_payment_account_verify_iban_empty
            .tr();
      });
      return;
    }
    // TODO: remplacer par la vraie logique de vérification (appel API).
    await _continue(EAccountType.bankTransfer);
  }

  Future<void> _submitMobile() async {
    if (_mobileController.text.trim().isEmpty) {
      setState(() {
        _mobileError =
            LocaleKeys.wallet_module_payment_account_verify_mobile_empty.tr();
      });
      return;
    }
    // TODO: remplacer par la vraie logique de vérification (appel API).
    await _continue(EAccountType.mobile);
  }

  /// S'il existe déjà un moyen de paiement pour ce type de compte, on ouvre
  /// l'écran de vérification/édition, sinon on ouvre l'écran de création.
  Future<void> _continue(EAccountType type) async {
    if (_hasPaymentMethod == true) {
      try {
        final preferences =
            await Modular.get<GetPaymentPreferencesUseCase>().call(NoParms());
        if (!mounted) return;
        final existing =
            preferences.where((p) => p.accountType == type).toList();
        if (existing.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EditPaymentAccountScreen(
                currentPaymentPreference: existing.first,
              ),
            ),
          );
          return;
        }
      } catch (err) {
        debugPrint(
          '[AccountVerificationScreen] payment preferences error: $err',
        );
      }
      return;
    }
    Modular.get<WalletRoutes>().addOrEditPaymentAccount.push();
  }

  // Masque une valeur, ex: BE845566552517 -> XXXXXXXXXXXXX17
  String _mask(String value) {
    if (value.length <= 2) return value;
    final visible = value.substring(value.length - 2);
    return 'X' * (value.length - 2) + visible;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              const SizedBox(height: 24),

              // Icône cadenas
              Center(
                child: Icon(
                  Icons.lock_rounded,
                  size: 88,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 24),

              // Titre
              Text(
                LocaleKeys.wallet_module_payment_account_verify_title.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // ----- IBAN -----
              _FieldBlock(
                label: LocaleKeys.wallet_module_payment_account_verify_iban_label
                    .tr(),
                controller: _ibanController,
                locked: _ibanLocked,
                errorText: _ibanError,
                maskedText: _mask(_ibanController.text),
                borderColor: _borderColor,
                lockedBg: _lockedBg,
                lockedText: _lockedText,
                errorColor: _errorColor,
                buttonColor: _buttonColor,
                buttonLabel: _buttonLabel,
                onChanged: (_) {
                  if (_ibanError != null) {
                    setState(() => _ibanError = null);
                  }
                },
                onSubmit: _submitIban,
              ),
              const SizedBox(height: 32),

              // ----- Mobile -----
              _FieldBlock(
                label:
                    LocaleKeys.wallet_module_payment_account_verify_mobile_label
                        .tr(),
                controller: _mobileController,
                locked: _mobileLocked,
                errorText: _mobileError,
                maskedText: _mask(_mobileController.text),
                borderColor: _borderColor,
                lockedBg: _lockedBg,
                lockedText: _lockedText,
                errorColor: _errorColor,
                buttonColor: _buttonColor,
                buttonLabel: _buttonLabel,
                onChanged: (_) {
                  if (_mobileError != null) {
                    setState(() => _mobileError = null);
                  }
                },
                onSubmit: _submitMobile,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Le bouton "Vérifier" ne s'affiche que si un moyen de paiement existe
  /// déjà pour ce type de compte ; sinon on affiche le bouton "Ajouter".
  String get _buttonLabel => _hasPaymentMethod == true
      ? LocaleKeys.wallet_module_payment_account_verify_verify.tr()
      : LocaleKeys.wallet_module_payment_account_verify_add.tr();
}

/// Bloc réutilisable : label + champ + (erreur) + bouton "Vérifier"/"Ajouter".
/// `locked = true` reproduit l'état grisé/masqué de la 2e capture.
class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.controller,
    required this.locked,
    required this.errorText,
    required this.maskedText,
    required this.borderColor,
    required this.lockedBg,
    required this.lockedText,
    required this.errorColor,
    required this.buttonColor,
    required this.buttonLabel,
    required this.onChanged,
    required this.onSubmit,
  });

  final String label;
  final TextEditingController controller;
  final bool locked;
  final String? errorText;
  final String maskedText;
  final Color borderColor;
  final Color lockedBg;
  final Color lockedText;
  final Color errorColor;
  final Color buttonColor;
  final String buttonLabel;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final hasError = !locked && errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Champ de saisie
        Container(
          decoration: BoxDecoration(
            color: locked ? lockedBg : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError ? errorColor : borderColor,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: locked
              ? Text(
                  maskedText,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
                    color: lockedText,
                  ),
                )
              : TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
        ),

        // Message d'erreur
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(fontSize: 12.5, color: errorColor),
          ),
        ],

        const SizedBox(height: 14),

        // Bouton Envoyer, aligné à droite
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: locked ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: locked ? lockedBg : buttonColor,
              foregroundColor: locked ? lockedText : Colors.white,
              disabledBackgroundColor: lockedBg,
              disabledForegroundColor: lockedText,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
