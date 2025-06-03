import 'package:flutter/material.dart' show AsyncSnapshot, ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/use_cases/use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/get_current_user_use_case.dart';

class CurrentUserCubit extends Cubit<AsyncSnapshot<UserEntity>> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  CurrentUserCubit(this._getCurrentUserUseCase)
      : super(const AsyncSnapshot.nothing()) {
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    emit(state.inState(ConnectionState.waiting));

    try {
      final data = await _getCurrentUserUseCase.call(NoParms());
      emit(AsyncSnapshot.withData(ConnectionState.done, data));
    } catch (error, stacktrace) {
      emit(AsyncSnapshot.withError(ConnectionState.none, error, stacktrace));
    }
  }
}
