import 'package:country_code_picker/country_code_picker.dart' show CountryCode;
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http_exceptions.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/data/models/monetization_account_model.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_current_user_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/save_monetization_account_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/upload_monetization_document_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/result_feedback_modals.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../../../core/generated/locale_keys.g.dart';
import '../../helpers/image_picker_helper.dart';

const _textSecondary = Color(0xFF6B7280);
const _fieldFillDisabled = Color(0xFFECEDF1);
const _fieldFill = Color(0xFFF2F3F7);
const _dashedBorder = Color(0xFFD9DBE3);
const _primaryButton = Color(0xFF1A1A2E);

String _flagEmoji(String iso) {
  final code = iso.toUpperCase();
  return String.fromCharCodes(
    code.codeUnits.map((u) => 0x1F1E6 + u - 0x41),
  );
}

class TaxIdentifierScreen extends StatefulWidget {
  /// Existing monetization account used to prefill the form (update flow).
  final MonetizationAccountModel? account;

  const TaxIdentifierScreen({super.key, this.account});

  @override
  State<TaxIdentifierScreen> createState() => _TaxIdentifierScreenState();
}

class _TaxIdentifierScreenState extends State<TaxIdentifierScreen> {
  static const _accountTypeParticulier = 'particulier';

  final _formKey = GlobalKey<FormState>();
  final _taxIdController = TextEditingController();

  CountryCode? _country;
  XFile? _documentXFile;
  String? _documentName;

  /// Document URL from the previously submitted account (if any). Reused on
  /// submit when the user does not pick a new file.
  String? _existingDocumentUrl;

  bool _loadingCountry = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _prefillFromAccount();
    _loadCountry();
  }

  void _prefillFromAccount() {
    final account = widget.account;
    if (account == null) return;
    _taxIdController.text = account.fiscalIdNumber;
    _existingDocumentUrl =
        (account.documentUrl.isNotEmpty) ? account.documentUrl : null;
    final url = Uri.tryParse(account.documentUrl);
    _documentName = url?.pathSegments.lastOrNull;
  }

  @override
  void dispose() {
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _loadCountry() async {
    try {
      final user = await Modular.get<GetCurrentUserUseCase>().call(NoParms());
      _country = CountryCode.tryFromCountryCode(user.pays.toUpperCase()) ??
          CountryCode.fromCountryCode('CM');
    } catch (_) {
      _country = CountryCode.fromCountryCode('CM');
    }
    if (!mounted) return;
    setState(() => _loadingCountry = false);
  }

  Future<void> _pickDocument() async {
    ImagePickerHelper.showPickImage(
      context,
      onImagePicked: (image) {
        if (image == null) return;
        setState(() {
          _documentXFile = image;
          _documentName = image.name;
        });
      },
    );
  }

  /// Creates or updates the 'particulier' monetization account
  /// (POST /account/monetization-accounts). If an account of the same type
  /// already exists, it is updated and its status goes back to pending.
  /// A new supporting document is uploaded (POST /account/upload) only when
  /// the user picked a new file; otherwise the previously submitted URL is
  /// reused.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final document = _documentXFile;
    if (document == null && _existingDocumentUrl == null) {
      UiAlertHelpers.showErrorToast(
        LocaleKeys.wallet_module_tax_identifier_screen_document_missing.tr(),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      // 1. Get the document URL: upload the newly picked file, or reuse the
      // previously submitted one.
      final documentUrl = document != null
          ? await Modular.get<UploadMonetizationDocumentUseCase>().call(
              UploadMonetizationDocumentParams(
                filePath: document.path,
                fileName: document.name,
              ),
            )
          : _existingDocumentUrl!;

      // 2. Save the monetization account with the document URL.
      await Modular.get<SaveMonetizationAccountUseCase>().call(
        SaveMonetizationAccountParams(
          accountType: _accountTypeParticulier,
          fiscalIdNumber: _taxIdController.text.trim(),
          documentUrl: documentUrl,
        ),
      );

      if (!mounted) return;
      await SuccessResultModal.show(
        context,
        title:
            LocaleKeys.wallet_module_tax_identifier_screen_success_title.tr(),
        description: LocaleKeys
            .wallet_module_tax_identifier_screen_success_description
            .tr(),
        buttonText: LocaleKeys.wallet_module_tax_identifier_screen_continue.tr(),
        onAction: () {
          if (Modular.to.canPop()) {
            Modular.to.pop(true);
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      final serverMessage = e is MyHttpException ? e.message : null;
      await ErrorResultModal.show(
        context,
        title: LocaleKeys.wallet_module_tax_identifier_screen_error_title.tr(),
        description: (serverMessage != null && serverMessage.isNotEmpty)
            ? serverMessage
            : LocaleKeys
                .wallet_module_tax_identifier_screen_error_description
                .tr(),
        buttonText: LocaleKeys.wallet_module_tax_identifier_screen_retry.tr(),
        onAction: () {},
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
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: Text(
          LocaleKeys.wallet_module_tax_identifier_screen_title.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: _loadingCountry
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Text(
                      LocaleKeys.wallet_module_tax_identifier_screen_intro.tr(),
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      LocaleKeys
                          .wallet_module_tax_identifier_screen_country_label
                          .tr(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: _textSecondary,
                      ),
                    ),
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
                          Text(
                            _flagEmoji(_country?.code ?? ''),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _country?.name ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: _textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      LocaleKeys
                          .wallet_module_tax_identifier_screen_tax_id_label
                          .tr(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _taxIdController,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? LocaleKeys
                              .wallet_module_tax_identifier_screen_field_required
                              .tr()
                          : null,
                      decoration: InputDecoration(
                        hintText: LocaleKeys
                            .wallet_module_tax_identifier_screen_tax_id_hint
                            .tr(),
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9CA3AF),
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
                    ),
                    const SizedBox(height: 26),
                    Text(
                      LocaleKeys
                          .wallet_module_tax_identifier_screen_document_label
                          .tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DashedUploadCard(
                      fileName: _documentName,
                      onPickFile: _pickDocument,
                    ),
                    const SizedBox(height: 32),
                    ActionButton(
                      text: LocaleKeys.wallet_module_tax_identifier_screen_save
                          .tr(),
                      isLoading: _submitting,
                      backgroundColor: Colors.black,
                      onPressed: _submit,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Upload card
// ---------------------------------------------------------------------------

class _DashedUploadCard extends StatelessWidget {
  final String? fileName;
  final VoidCallback onPickFile;

  const _DashedUploadCard({required this.onPickFile, this.fileName});

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;
    return InkWell(
      onTap: onPickFile,
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: const _DashedRRectPainter(
          radius: 16,
          borderColor: _dashedBorder,
          fillColor: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _fieldFillDisabled,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasFile
                      ? Icons.check_circle_outline
                      : Icons.cloud_upload_outlined,
                  color: hasFile ? _primaryButton : _textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                hasFile
                    ? fileName!
                    : LocaleKeys.wallet_module_tax_identifier_screen_choose_file
                        .tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                LocaleKeys.wallet_module_tax_identifier_screen_file_format.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final double radius;
  final Color borderColor;
  final Color fillColor;

  const _DashedRRectPainter({
    required this.radius,
    required this.borderColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    canvas.drawRRect(rrect, Paint()..color = fillColor);

    final dashedPath = _dashPath(
      Path()..addRRect(rrect),
      dashLength: 6,
      gapLength: 5,
    );
    canvas.drawPath(
      dashedPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  Path _dashPath(
    Path source, {
    required double dashLength,
    required double gapLength,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final segmentLength = draw ? dashLength : gapLength;
        final next = (distance + segmentLength).clamp(0.0, metric.length);
        if (draw) {
          dest.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.borderColor != borderColor ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.radius != radius;
}
