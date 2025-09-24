import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/flutter_bantu_wallet_module.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/enums/e_kyc_status.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/payment_preference_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/account/get_kyc_status_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/localization/string_translate_extension.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/withdrawal_description.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../../core/use_cases/use_case.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/payment_preference/get_payment_preferences_use_case.dart';
import '../../../domain/entities/user_balance_entity.dart';

import '../../../presentation/cubits/current_user_cubit.dart';

import '../../cubits/user_balance_cubit.dart';
import '../../widgets/action_button.dart';
import '../../widgets/my_header_bar.dart';

import 'widgets/registered_payment_method.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});

  void _onViewDetails() => Modular.get<WalletRoutes>().transactions.push();

  void _goToKycForm() => WalletModule.goToKycForm();

  void _onRequestWithdrawal() {
    Modular.get<WalletRoutes>().withdrawalRequestForm.push();
    // launchUrlString(
    //   '${ApiConstants.websiteUrl}/balance/withdraw',
    //   mode: LaunchMode.externalApplication,
    // );
  }

  void _onAddPaymentPreference() {
    Modular.get<WalletRoutes>().addOrEditPaymentAccount.push();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHeaderBar(
                title: LocaleKeys.wallet_module_withdrawal_page_title.tr(),
              ),
              const SizedBox(height: 7.5),
              const WithdrawalDescription(),
              const SizedBox(height: 24),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
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
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>,
                          bool>(
                        bloc: Modular.get<CurrentUserCubit>(),
                        selector: (snap) => snap.data?.isAfrican ?? false,
                        builder: (context, isAfrican) => BlocBuilder<
                            UserBalanceCubit, AsyncSnapshot<UserBalanceEntity>>(
                          bloc: Modular.get<UserBalanceCubit>(),
                          builder: (context, balanceSnap) => Text(
                            balanceSnap.hasData
                                ? NumberFormat.currency(
                                    symbol: isAfrican ? 'F CFA' : '€',
                                  ).format(
                                    isAfrican
                                        ? balanceSnap.data?.xaf
                                        : balanceSnap.data?.eur,
                                  )
                                : '...',
                            style: TextStyle(
                              fontSize: 20,
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBAB9B9),
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.wallet_module_withdrawal_page_see_details.tr(),
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                LocaleKeys
                    .wallet_module_withdrawal_page_Your_registered_payment_account
                    .tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: Future.wait([
                  Modular.get<GetKycStatusUseCase>().call(NoParms()),
                  Modular.get<GetPaymentPreferencesUseCase>().call(NoParms()),
                ]),
                builder: (context, snap) {
                  final error = snap.error;
                  if (error != null) {
                    debugPrint(error.toString());
                    debugPrintStack(
                      label: error.toString(),
                      stackTrace: snap.stackTrace,
                    );
                  }

                  final kycStatus = snap.data?.first as EKycStatus?;
                  final paymentPreferences =
                      snap.data?.last as List<PaymentPreferenceEntity>?;

                  if (kycStatus == null || paymentPreferences == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return Column(
                    children: [
                      if (paymentPreferences.isEmpty) ...[
                        Text(
                          LocaleKeys
                              .wallet_module_withdrawal_page_you_can_receive_payment_yet
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (kycStatus != EKycStatus.success)
                        ActionButton(
                          text: LocaleKeys
                              .wallet_module_withdrawal_page_check_your_identity
                              .tr(),
                          onPressed: _goToKycForm,
                          fullWidth: true,
                        )
                      else if (paymentPreferences.isEmpty)
                        ActionButton(
                          text: LocaleKeys
                              .wallet_module_withdrawal_page_add_a_payment_method
                              .tr(),
                          onPressed: _onAddPaymentPreference,
                          fullWidth: true,
                        )
                      else ...[
                        ...paymentPreferences.map(RegisteredPaymentMethod.new),
                        const SizedBox(height: 20),
                        ActionButton(
                          text: LocaleKeys
                              .wallet_module_withdrawal_page_request_payment
                              .tr(),
                          onPressed: _onRequestWithdrawal,
                          fullWidth: true,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
