import '../../../../core/network/my_http/my_http.dart';
import '../models/user_balance_model.dart';

abstract class BalanceDataSource {
  Future<UserBalanceModel> getUserBalance();
}

class BalanceRemoteDataSourceImpl implements BalanceDataSource {
  final MyHttpClient _client;

  BalanceRemoteDataSourceImpl(this._client);

  @override
  Future<UserBalanceModel> getUserBalance() {
    return _client
        .get('/balance')
        .then((r) => UserBalanceModel.fromJson(r.data));
  }
}
