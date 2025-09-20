import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_withdrawal_eligibility.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/check_withdrawal_eligibility_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/withdrawal/generate_withdrawal_payment_slip_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/value_objects/requests/create_withdrawal_request.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';

import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../../core/network/api_constants.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_balance_entity.dart';

import '../../../presentation/cubits/current_user_cubit.dart';

import '../../cubits/user_balance_cubit.dart';
import '../../widgets/action_button.dart';
import '../../widgets/my_header_bar.dart';

part 'withdrawal_request_form_controller.dart';

class WithdrawalRequestFormPage extends StatelessWidget {
  const WithdrawalRequestFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScreenControllerBuilder(
            create: _WithdrawalRequestFormController.new,
            builder: (context, ctrl) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyHeaderBar(
                  title: LocaleKeys
                      .wallet_module_withdrawal_process_request_title
                      .tr(namedArgs: {'id': ctrl.slip ?? '...'}),
                ),
                const SizedBox(height: 7.5),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colorScheme.onSurface,
                      ),
                      TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys
                                .wallet_module_withdrawal_process_fees_warning1
                                .tr(),
                          ),
                          TextSpan(
                            text: LocaleKeys
                                .wallet_module_withdrawal_process_fees_warning2
                                .tr(),
                            style: TextStyle(color: colorScheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = ctrl.onPrivatePolicy,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: FittedBox(
                                child: Text(
                                  LocaleKeys
                                      .wallet_module_withdrawal_page_financial_account_balance
                                      .tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            BlocSelector<UserBalanceCubit,
                                AsyncSnapshot<UserBalanceEntity>, String?>(
                              bloc: Modular.get<UserBalanceCubit>(),
                              selector: (state) =>
                                  state.data?.financialWalletNumber,
                              builder: (context, financialWalletNumber) =>
                                  Flexible(
                                child: FittedBox(
                                  child: Text(
                                    '(ID: $financialWalletNumber)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        BlocSelector<CurrentUserCubit,
                            AsyncSnapshot<UserEntity>, bool>(
                          bloc: Modular.get<CurrentUserCubit>(),
                          selector: (snap) => snap.data?.isAfrican ?? false,
                          builder: (context, isAfrican) => BlocBuilder<
                              UserBalanceCubit,
                              AsyncSnapshot<UserBalanceEntity>>(
                            bloc: Modular.get<UserBalanceCubit>(),
                            builder: (context, balanceSnap) => Text(
                              balanceSnap.hasData
                                  ? NumberFormat.currency(symbol: ' € ')
                                      .format(balanceSnap.data?.eur)
                                  : '...',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  LocaleKeys
                      .wallet_module_withdrawal_process_amount_to_withdraw_in_eur
                      .tr(),
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: ctrl.amountCtrl,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: LocaleKeys
                        .wallet_module_withdrawal_process_amount_to_withdraw_in_eur
                        .tr(),
                    filled: true,
                    fillColor: const Color(0xFFEBEBEB),
                    hintStyle: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFFA5A5A5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    errorText: ctrl.error,
                  ),
                ),
                const SizedBox(height: 15),
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
