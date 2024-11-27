import '../entities/user_balance.dart';

abstract class BalanceRepository {
  Future<UserBalance> getUserBalance();
}
