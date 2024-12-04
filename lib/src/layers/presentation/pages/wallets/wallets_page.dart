import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bantu_wallet_module/src/core/network/my_http/my_http.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/entities/user_entity.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/exchange_bzc_to_fiat_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/domain/use_cases/get_bzc_currency_converter_use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/pages/withdrawal/withdrawal_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../domain/entities/user_balance_entity.dart';
import '../../cubits/user_balance_cubit.dart';
import '../../helpers/ui_alert_helpers.dart';
import '../../widgets/my_header_bar.dart';
import '../../widgets/my_small_button.dart';

part 'widgets/financial_account_box.dart';
part 'widgets/beatzcoin_account_box.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  static const pageRoute = '/wallets';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>, bool>(
          bloc: Modular.get<CurrentUserCubit>(),
          selector: (snap) => snap.data?.isAfrican ?? false,
          builder: (context, isAfrican) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyHeaderBar(title: LocaleKeys.wallets_page_title.tr()),
              const SizedBox(height: 7.5),
              Container(
                padding: const EdgeInsets.all(5),
                color: Color(0xFFFFCCCC).withOpacity(0.5),
                child: RichText(
                  text: TextSpan(
                    text: LocaleKeys.wallets_page_description.tr(),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: LocaleKeys.wallets_page_description2.tr(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              _FinancialAccountBox(isAfrican: isAfrican),
              SizedBox(height: 16.0),
              _BeatzacoinAccountBox(isAfrican: isAfrican),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
