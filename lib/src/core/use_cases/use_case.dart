import 'package:equatable/equatable.dart';

abstract class UseCase<T, Params> {
  const UseCase();

  Future<T> call(Params params);
}

final class NoParms extends Equatable {
  @override
  List<Object?> get props => [];
}
