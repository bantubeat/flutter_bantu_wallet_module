import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_balance.dart';
import '../../domain/use_cases/get_user_balance_use_case.dart';

class UserBalanceCubit extends Cubit<AsyncSnapshot<UserBalance>> {
  final GetUserBalanceUseCase getUserBalanceUseCase;

  UserBalanceCubit(this.getUserBalanceUseCase) : super(AsyncSnapshot.nothing());

  void fetchUserBalance() async {
    emit(state.inState(ConnectionState.waiting));

    try {
      final data = await getUserBalanceUseCase.call(null);
      emit(AsyncSnapshot.withData(ConnectionState.done, data));
    } catch (error, stacktrace) {
      emit(AsyncSnapshot.withError(ConnectionState.none, error, stacktrace));
    }
  }
}
