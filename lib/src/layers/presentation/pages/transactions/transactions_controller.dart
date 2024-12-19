part of 'transactions_page.dart';

class _TransactionsController extends ScreenController {
  _TransactionsController(super.state);

  final userBalanceCubit = Modular.get<UserBalanceCubit>();

  static const _pageSize = 20;
  final List<EFinancialTxStatus> statuses = [];
  final List<EFinancialTxType> types = [];

  bool _isBzcAccount = false;
  bool get isBzcAccount => _isBzcAccount;

  final pagingController = PagingController<int, FinancialTransactionEntity>(
    firstPageKey: 1,
  );

  @override
  @protected
  void onInit() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  @protected
  void onDispose() {
    pagingController.dispose();
  }

  String get walletNumber {
    if (userBalanceCubit.state.hasError) return 'E';

    return _isBzcAccount
        ? (userBalanceCubit.state.data?.beatzcoinWalletNumber ?? '...')
        : (userBalanceCubit.state.data?.financialWalletNumber ?? '...');
  }

  void onStatusTap(EFinancialTxStatus? status) {
    statuses.clear();
    if (status != null) statuses.add(status);
    pagingController.refresh();
    refreshUI();
  }

  void onTypeTap(EFinancialTxType? type) {
    types.clear();
    if (type != null) types.add(type);
    pagingController.refresh();
    refreshUI();
  }

  void switchAccount() {
    _isBzcAccount = !_isBzcAccount;
    statuses.clear();
    types.clear();
    pagingController.refresh();
    refreshUI();
  }

  void _fetchPage(int pageKey) async {
    try {
      final newItems = await Modular.get<GetTransactionsUseCase>().call(
        GetTransactionsParams(
          page: pageKey,
          limit: _pageSize,
          statuses: statuses,
          types: types,
          isBzcAccount: _isBzcAccount,
        ),
      );
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
