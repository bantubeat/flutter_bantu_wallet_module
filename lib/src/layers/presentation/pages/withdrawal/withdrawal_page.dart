import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/use_cases/use_case.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/get_payment_preferences_use_case.dart';
import '../../../domain/entities/user_balance_entity.dart';

import '../../../presentation/cubits/current_user_cubit.dart';
import '../../../presentation/navigation/wallet_routes.dart';

import '../../cubits/user_balance_cubit.dart';
import '../../widgets/action_button.dart';
import '../../widgets/my_header_bar.dart';

import 'widgets/registered_payment_method.dart';

class WithdrawalPage extends StatelessWidget {
  const WithdrawalPage({super.key});

  // TODO: ensure Historique compte financier
  void onViewDetails() => Modular.get<WalletRoutes>().transactions.push();

  void onRequestWithdrawal() {
    launchUrlString(
      '${ApiConstants.websiteUrl}/balance/withdraw',
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.onPrimary,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHeaderBar(
                title: LocaleKeys.wallet_module_withdrawal_page_title.tr(),
              ),
              const SizedBox(height: 7.5),
              Container(
                padding: const EdgeInsets.all(5),
                color: Color(0xFFFFCCCC).withOpacity(0.5),
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.wallet_module_withdrawal_page_description.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              /*
            SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Les demandes de paiement sont effectuées via votre profil Bantubeat.',
                      style: const TextStyle(
                        color: Color.fromRGBO(18, 18, 18, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ), */
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          LocaleKeys
                              .wallet_module_withdrawal_page_financial_account_balance
                              .tr(),
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        /*
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            '', // TODO: '(ID: ${'1AEH1525N524N525I'.toString()})',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ), */
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
                                  symbol: isAfrican ? 'CFA' : '€',
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
                      DateFormat('dd MM yyyy').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBAB9B9),
                  minimumSize: Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.wallet_module_withdrawal_page_see_details.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                LocaleKeys
                    .wallet_module_withdrawal_page_Your_registered_payment_account
                    .tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder(
                future: Modular.get<GetPaymentPreferencesUseCase>().call(
                  NoParms(),
                ),
                builder: (context, snap) => Visibility(
                  visible: snap.data?.isNotEmpty ?? false,
                  replacement: const SizedBox.shrink(),
                  child: Column(
                    children: [
                      ...(snap.data ?? []).map(
                        (paymentPreference) => RegisteredPaymentMethod(
                          paymentPreference: paymentPreference,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ActionButton(
                text: LocaleKeys.wallet_module_withdrawal_page_request_payment
                    .tr(),
                onPressed: onRequestWithdrawal,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
