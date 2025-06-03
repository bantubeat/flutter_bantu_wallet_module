import 'package:flutter/material.dart';
import 'package:flutter_bantu_wallet_module/src/core/use_cases/use_case.dart';
import 'package:flutter_bantu_wallet_module/src/layers/presentation/helpers/ui_alert_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_balance_entity.dart';
import '../../domain/use_cases/get_user_balance_use_case.dart';

class UserBalanceCubit extends Cubit<AsyncSnapshot<UserBalanceEntity>> {
  final GetUserBalanceUseCase _getUserBalanceUseCase;

  UserBalanceCubit(this._getUserBalanceUseCase)
      : super(const AsyncSnapshot.nothing()) {
    fetchUserBalance();
  }

  void fetchUserBalance() async {
    emit(state.inState(ConnectionState.waiting));

    try {
      final data = await _getUserBalanceUseCase.call(NoParms());
      emit(AsyncSnapshot.withData(ConnectionState.done, data));
    } catch (error, stacktrace) {
      UiAlertHelpers.showErrorToast(error.toString());
      debugPrintStack(label: error.toString(), stackTrace: stacktrace);
      emit(AsyncSnapshot.withError(ConnectionState.none, error, stacktrace));
      rethrow;
    }
  }
}
