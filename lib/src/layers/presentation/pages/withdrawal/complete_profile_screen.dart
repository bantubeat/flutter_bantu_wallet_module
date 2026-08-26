import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http_exceptions.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_current_user_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/save_personal_infos_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/personal_infos_input.dart';

import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_modular/flutter_modular.dart';

const _textPrimary = Color(0xFF1A1A2E);
const _textSecondary = Color(0xFF6B7280);
const _fieldFill = Color(0xFFF2F3F7);
const _fieldFillDisabled = Color(0xFFECEDF1);
const _primaryButton = Color(0xFF1F2430);
const _iconGrey = Color(0xFF9AA0A8);

const _appBarTitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: _textPrimary,
);
const _h1 = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w800,
  color: _textPrimary,
);
const _body = TextStyle(
  fontSize: 14,
  height: 1.5,
  color: _textSecondary,
);
const _fieldLabel = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  letterSpacing: 1,
  color: _textSecondary,
);
const _fieldValue = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: _textPrimary,
);
const _fieldHint = TextStyle(
  fontSize: 15,
  color: Color(0xFF9CA3AF),
);

String _flagEmoji(String iso) {
  final code = iso.toUpperCase();
  return String.fromCharCodes(
    code.codeUnits.map((u) => 0x1F1E6 + u - 0x41),
  );
}

enum _Gender { homme, femme, autre }

extension on _Gender {
  String get label => switch (this) {
        _Gender.homme => 'Homme',
        _Gender.femme => 'Femme',
        _Gender.autre => 'Autre',
      };

  /// API value sent in the `gender` field of /account/personal-infos.
  String get apiValue => switch (this) {
        _Gender.homme => 'M',
        _Gender.femme => 'F',
        _Gender.autre => 'O',
      };
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _addressController = TextEditingController();

  CountryCode? _country;
  _Gender? _gender;
  DateTime? _dob;
  int? _birthyear;

  bool _loadingCountry = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadCountry();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _neighborhoodController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  /// Loads the connected user and prefills every field already known.
  Future<void> _loadCountry() async {
    try {
      final user = await Modular.get<GetCurrentUserUseCase>().call(NoParms());
      _country = CountryCode.tryFromCountryCode(user.pays.toUpperCase()) ??
          CountryCode.fromCountryCode('CM');
      _firstNameController.text = user.prenom ?? '';
      _lastNameController.text = user.nom ?? '';
      _cityController.text = user.city ?? '';
      _postalCodeController.text = user.postalCode ?? '';
      _neighborhoodController.text = user.neighborhood ?? '';
      _addressController.text = user.street ?? '';
      _birthyear = user.birthyear > 0 ? user.birthyear : null;
      if (user.gender != null) {
        _gender = switch (user.gender) {
          'M' => _Gender.homme,
          'F' => _Gender.femme,
          _ => _Gender.autre,
        };
      }
    } catch (_) {
      _country = CountryCode.fromCountryCode('CM');
    }
    if (!mounted) return;
    setState(() => _loadingCountry = false);
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ??
          (_birthyear != null ? DateTime(_birthyear!, 6, 15) : DateTime(now.year - 25)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Ce champ est requis' : null;

  /// Saves the connected user's personal informations via
  /// POST /account/personal-infos.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      UiAlertHelpers.showErrorToast(
        'Veuillez renseigner votre date de naissance.',
      );
      return;
    }
    if (_gender == null) {
      UiAlertHelpers.showErrorToast('Veuillez sélectionner votre genre.');
      return;
    }

    setState(() => _submitting = true);
    try {
      await Modular.get<SavePersonalInfosUseCase>().call(
        PersonalInfosInput(
          prenom: _firstNameController.text.trim(),
          nom: _lastNameController.text.trim(),
          birthdate:
              '${_dob!.year.toString().padLeft(4, '0')}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
          gender: _gender!.apiValue,
          countryIso2: _country?.code ?? '',
          cityName: _cityController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          neighborhood: _neighborhoodController.text.trim(),
          street: _addressController.text.trim(),
        ),
      );
      if (!mounted) return;
      UiAlertHelpers.showSuccessToast('Profil mis à jour avec succès');
      if (Modular.to.canPop()) {
        Modular.to.pop();
      }
    } catch (e) {
      if (!mounted) return;
      final serverMessage = e is MyHttpException ? e.message : null;
      UiAlertHelpers.showErrorToast(
        (serverMessage != null && serverMessage.isNotEmpty)
            ? serverMessage
            : 'Une erreur est survenue lors de la mise à jour. Veuillez réessayer.',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: _textPrimary),
        title: const Text('Informations personnelles', style: _appBarTitle),
      ),
      body: _loadingCountry
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    const Text('Compléter mon profil', style: _h1),
                    const SizedBox(height: 10),
                    const Text(
                      'Veuillez renseigner vos informations pour finaliser votre inscription.',
                      style: _body,
                    ),
                    const SizedBox(height: 26),
                    _IconTextField(
                      label: 'PRÉNOM*',
                      controller: _firstNameController,
                      hint: 'Entrez votre prénom',
                      icon: Icons.person_outline_rounded,
                      validator: _requiredValidator,
                    ),
                    _IconTextField(
                      label: 'NOM*',
                      controller: _lastNameController,
                      hint: 'Entrez votre nom',
                      icon: Icons.badge_outlined,
                      validator: _requiredValidator,
                    ),
                    _IconTextField(
                      label: 'DATE DE NAISSANCE*',
                      controller: _dobController,
                      hint: 'mm/dd/yyyy',
                      icon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: _pickDob,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Ce champ est requis'
                          : null,
                    ),
                    const Text('GENRE*', style: _fieldLabel),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<_Gender>(
                      initialValue: _gender,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _textSecondary,
                      ),
                      style: _fieldValue,
                      decoration: InputDecoration(
                        hintText: 'Sélectionner',
                        hintStyle: _fieldHint,
                        prefixIcon: const Icon(
                          Icons.wc_rounded,
                          color: _iconGrey,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: _fieldFill,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: _primaryButton,
                            width: 1.5,
                          ),
                        ),
                      ),
                      items: _Gender.values
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(g.label),
                            ),
                          )
                          .toList(),
                      onChanged: (g) => setState(() => _gender = g),
                      validator: (g) =>
                          g == null ? 'Ce champ est requis' : null,
                    ),
                    const SizedBox(height: 18),
                    const Text('PAYS*', style: _fieldLabel),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: _fieldFillDisabled,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.public_rounded,
                            color: _iconGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _flagEmoji(_country?.code ?? ''),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _country?.name ?? '',
                              style: _fieldValue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _IconTextField(
                      label: 'VILLE*',
                      controller: _cityController,
                      hint: 'Ex: Douala, Yaoundé...',
                      icon: Icons.location_city_outlined,
                      validator: _requiredValidator,
                    ),
                    _IconTextField(
                      label: 'CODE POSTAL*',
                      controller: _postalCodeController,
                      hint: 'Entrez le code postal de la ville',
                      icon: Icons.location_city_outlined,
                      validator: _requiredValidator,
                    ),
                    _IconTextField(
                      label: 'QUARTIER',
                      controller: _neighborhoodController,
                      hint: 'Entrez votre quartier',
                      icon: Icons.map_outlined,
                    ),
                    _IconTextField(
                      label: 'RUE ET N°/ LIEU DIT*',
                      controller: _addressController,
                      hint:
                          'Précisez votre adresse (ex: Derrière la pharmacie...)',
                      icon: Icons.place_outlined,
                      maxLines: 2,
                      validator: _requiredValidator,
                    ),
                    const SizedBox(height: 24),
                    ActionButton(
                      text: 'Enregistrer',
                      isLoading: _submitting,
                      backgroundColor: _primaryButton,
                      trailingIcon: const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Text field with a leading icon + label above, matching the mockup style.
// ---------------------------------------------------------------------------

class _IconTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;
  final String? Function(String?)? validator;

  const _IconTextField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _fieldLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            validator: validator,
            maxLines: maxLines,
            style: _fieldValue,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: _fieldHint,
              prefixIcon: Icon(icon, color: _iconGrey, size: 20),
              filled: true,
              fillColor: _fieldFill,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _primaryButton, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
