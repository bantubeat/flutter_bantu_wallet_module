import '../../../../core/network/my_http/my_http.dart';
import '../models/currency_item_model.dart';
import '../models/user_balance_model.dart';

///
/// This is a Bantubeat API Data Source, all methods are named regarding to the
/// api path to call, first is the HTTP METHOD to use GET, POST, etc
/// then the second is the uri in cameCase, so GET /public/all-currencies will
/// be  get$publicAllCurrencies.
final class BantubeatApiDataSource {
  final MyHttpClient client;
  final MyHttpClient cachedClient;

  const BantubeatApiDataSource({
    required this.client,
    required this.cachedClient,
  });

  Future<UserBalanceModel> get$balance() {
    return client
        .get('/balance')
        .then((r) => UserBalanceModel.fromJson(r.data));
  }

  Future<List<CurrencyItemModel>> get$publicAllCurrencies() {
    return cachedClient
        .get('/public/all-currencies')
        .then((r) => r.data as List)
        .then((list) => list.map((e) => e as Map<String, dynamic>))
        .then((jsonList) => jsonList.map(CurrencyItemModel.fromJson).toList());
  }
}
