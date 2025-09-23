import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/generated/locale_keys.g.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_account_type.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_withdrawal_response_status.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/request_withdrawal_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/send_withdrawal_mail_otp_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/create_withdrawal_request.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/user_balance_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/action_button.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/my_header_bar.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/otp_code_modal.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:intl/intl.dart' show DateFormat;

part 'withdrawal_request_resume_controller.dart';

class WithdrawalRequestResumePage extends StatelessWidget {
  final CreateWithdrawalRequest param;

  const WithdrawalRequestResumePage(this.param);

  // Helper for the bottom address/contact info
  Widget _buildFooterInfo() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'BANTUBEAT\nRue des Hiercheuses 140, 6001 Charleroi/Belgique N° entreprise : 802237609 - Tva: 0802237609 Contact@bantubeat.com\nTel: +32471307504',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  // Helper for the bank account details section
  Widget _buildBankAccountInfo(ColorScheme colorScheme) {
    final isMobile = param.paymentPreference.accountType == EAccountType.mobile;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.radio_button_checked,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: FittedBox(
                  child: Text(
                    isMobile
                        ? LocaleKeys
                            .wallet_module_withdrawal_process_use_my_mobile_account
                            .tr()
                        : LocaleKeys
                            .wallet_module_withdrawal_process_use_my_bank_account
                            .tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            _buildInfoRow(
              '${LocaleKeys.wallet_module_common_gsm_number.tr()} :',
              param.paymentPreference.detailPhone ?? '',
            ),
            _buildInfoRow(
              '${LocaleKeys.wallet_module_common_operator.tr()} :',
              param.paymentPreference.detailOperator ?? '',
            ),
          ] else ...[
            _buildInfoRow(
              '${LocaleKeys.wallet_module_common_iban.tr()} :',
              param.paymentPreference.detailIban ?? '',
            ),
            _buildInfoRow(
              '${LocaleKeys.wallet_module_common_swift_code.tr()} :',
              param.paymentPreference.detailBic ?? '',
            ),
            _buildInfoRow(
              '${LocaleKeys.wallet_module_common_bank_name.tr()} :',
              param.paymentPreference.detailBankName ?? '',
            ),
          ],
          _buildInfoRow(
            '${LocaleKeys.wallet_module_common_country.tr()} :',
            param.paymentPreference.detailCountry ?? '',
          ),
        ],
      ),
    );
  }

  // Reusable row for key-value text pairs
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildResume(ColorScheme colorScheme, String fullName) {
    return Text.rich(
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.0,
        color: colorScheme.onSurface,
      ),
      TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys
                .wallet_module_withdrawal_process_resume_description1
                .tr(),
          ),
          TextSpan(
            text: fullName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: LocaleKeys
                .wallet_module_withdrawal_process_resume_description2
                .tr(),
          ),
          TextSpan(
            text: param.financialAccountId,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: LocaleKeys
                .wallet_module_withdrawal_process_resume_description3
                .tr(),
          ),
          TextSpan(
            text: '${param.amount.toString()}€',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: LocaleKeys
                .wallet_module_withdrawal_process_resume_description4
                .tr(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOtherTextWidgets(
    ColorScheme colorScheme, {
    required String fullName,
    required String country,
  }) {
    return [
      Text(
        LocaleKeys.wallet_module_withdrawal_process_i_acceptes_fees.tr(),
        style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
      ),
      const SizedBox(height: 30),
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          children: [
            TextSpan(
              text: LocaleKeys.wallet_module_withdrawal_process_place_and_date1
                  .tr(),
            ),
            TextSpan(
              text: country.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: LocaleKeys.wallet_module_withdrawal_process_place_and_date2
                  .tr(),
            ),
            TextSpan(
              text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: LocaleKeys.wallet_module_withdrawal_process_place_and_date3
                  .tr(),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          children: [
            TextSpan(
              text: LocaleKeys.wallet_module_withdrawal_process_signature1.tr(),
            ),
            TextSpan(
              text: fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: LocaleKeys.wallet_module_withdrawal_process_signature2.tr(),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        LocaleKeys.wallet_module_common_read_and_approved.tr(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScreenControllerBuilder(
            create: (s) => _WithdrawalRequestResumeController(s, param),
            builder: (context, ctrl) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyHeaderBar(
                  title: LocaleKeys
                      .wallet_module_withdrawal_process_request_title
                      .tr(namedArgs: {'id': param.paymentSlip}),
                ),
                const SizedBox(height: 7.5),
                _buildResume(colorScheme, ctrl.fullName),
                const SizedBox(height: 20),
                _buildBankAccountInfo(colorScheme),
                const SizedBox(height: 20),
                ..._buildOtherTextWidgets(
                  colorScheme,
                  fullName: ctrl.fullName,
                  country: ctrl.countryName,
                ),
                const SizedBox(height: 24),
                _buildFooterInfo(),
                const SizedBox(height: 24),
                ActionButton(
                  isLoading: ctrl.isProcessing,
                  text: LocaleKeys.wallet_module_common_validate.tr(),
                  onPressed: ctrl.onSubmit,
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
