import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/cubits/current_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screen_controller/flutter_screen_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/generated/locale_keys.g.dart';
import '../../../domain/entities/financial_transaction_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/get_transactions_history_use_case.dart';
import '../../widgets/bantubeat_image_provider.dart';
import 'widgets/account_switcher.dart';
import 'widgets/transaction_filter.dart';
import 'widgets/transaction_item.dart';

part 'transactions_controller.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: colorScheme.onPrimary,
          title: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: BantubeatImageProvider(),
              ),
              const SizedBox(width: 5),
              Text(
                'Bantubeat',
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
            ],
          ),
          actions: [
            BlocSelector<CurrentUserCubit, AsyncSnapshot<UserEntity>, String?>(
              bloc: Modular.get(),
              selector: (snap) => snap.data?.photoUrl,
              builder: (context, photoUrl) => Skeletonizer(
                enabled: photoUrl != null,
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(photoUrl ?? ''),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: ScreenControllerBuilder(
          create: _TransactionsController.new,
          builder: (context, ctrl) => Column(
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.wallet_module_transaction_history_page_title.tr(),
                  style: TextStyle(
                    color: Color(0xFF49454F).withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AccountSwitcher(
                isBzcAccount: ctrl.isBzcAccount,
                onSelectBzcAccount: ctrl.switchAccount,
                onSelectFiatAccount: ctrl.switchAccount,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.wallet_module_transaction_history_page_account
                          .tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    /*
              Flexible(child: FittedBox(child: Text('(ID: 248152526526525)'))),
							*/
                  ],
                ),
              ),
              TransactionFilter(
                selectedStatus: ctrl.statuses.firstOrNull,
                selectedType: ctrl.types.firstOrNull,
                onStatusTap: !ctrl.isBzcAccount ? ctrl.onStatusTap : null,
                onTypeTap: ctrl.isBzcAccount ? ctrl.onTypeTap : null,
                onAllTap: ctrl.isBzcAccount
                    ? () => ctrl.onTypeTap(null)
                    : () => ctrl.onStatusTap(null),
              ),
              Expanded(
                child: PagedListView<int, FinancialTransactionEntity>(
                  padding: const EdgeInsets.all(16),
                  pagingController: ctrl.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (_, item, __) => TransactionItem(item),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
