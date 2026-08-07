import 'package:flutter_bantu_wallet_module/src/layers/presentation/widgets/json_parsing_utils.dart';

import '../../domain/entities/user_balance_entity.dart';

// ---- payment_account ----
class PaymentAccountModel extends PaymentAccountEntity {
  const PaymentAccountModel({
    required super.walletNumber,
    required super.balanceEur,
    required super.userCurrency,
    required super.userCurrencyCode,
    required super.userCurrencyBalance,
  });

  factory PaymentAccountModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return PaymentAccountModel(
      walletNumber: JsonParsingUtils.parseString(data['wallet_number']),
      balanceEur: JsonParsingUtils.parseDouble(data['balance_eur']),
      userCurrency: JsonParsingUtils.parseString(data['user_currency']),
      userCurrencyCode:
          JsonParsingUtils.parseString(data['user_currency_code']),
      userCurrencyBalance:
          JsonParsingUtils.parseDouble(data['user_currency_balance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_number': walletNumber,
      'balance_eur': balanceEur,
      'user_currency': userCurrency,
      'user_currency_code': userCurrencyCode,
      'user_currency_balance': userCurrencyBalance,
    };
  }
}

// ---- revenue_account.sub_accounts.{diamonds|stars} ----
class RevenueSubAccountModel extends RevenueSubAccountEntity {
  const RevenueSubAccountModel({
    required super.accountNumber,
    required super.balance,
  });

  factory RevenueSubAccountModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return RevenueSubAccountModel(
      accountNumber: JsonParsingUtils.parseString(data['account_number']),
      balance: JsonParsingUtils.parseDouble(data['balance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'balance': balance,
    };
  }
}

// ---- revenue_account ----
class RevenueAccountModel extends RevenueAccountEntity {
  const RevenueAccountModel({
    required super.walletNumber,
    required super.balanceEur,
    required super.userCurrency,
    required super.userCurrencyCode,
    required super.userCurrencyBalance,
    required RevenueSubAccountModel super.diamonds,
    required RevenueSubAccountModel super.stars,
  });

  factory RevenueAccountModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    final subAccounts = JsonParsingUtils.parseMap(data['sub_accounts']);

    return RevenueAccountModel(
      walletNumber: JsonParsingUtils.parseString(data['wallet_number']),
      balanceEur: JsonParsingUtils.parseDouble(data['balance_eur']),
      userCurrency: JsonParsingUtils.parseString(data['user_currency']),
      userCurrencyCode:
          JsonParsingUtils.parseString(data['user_currency_code']),
      userCurrencyBalance:
          JsonParsingUtils.parseDouble(data['user_currency_balance']),
      diamonds: RevenueSubAccountModel.fromJson(
        JsonParsingUtils.parseMap(subAccounts['diamonds']),
      ),
      stars: RevenueSubAccountModel.fromJson(
        JsonParsingUtils.parseMap(subAccounts['stars']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_number': walletNumber,
      'balance_eur': balanceEur,
      'user_currency': userCurrency,
      'user_currency_code': userCurrencyCode,
      'user_currency_balance': userCurrencyBalance,
      'sub_accounts': {
        'diamonds': (diamonds as RevenueSubAccountModel).toJson(),
        'stars': (stars as RevenueSubAccountModel).toJson(),
      },
    };
  }
}

// ---- beatzcoin_account ----
class BeatzcoinAccountModel extends BeatzcoinAccountEntity {
  const BeatzcoinAccountModel({
    required super.walletNumber,
    required super.balance,
  });

  factory BeatzcoinAccountModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};
    return BeatzcoinAccountModel(
      walletNumber: JsonParsingUtils.parseString(data['wallet_number']),
      balance: JsonParsingUtils.parseDouble(data['balance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet_number': walletNumber,
      'balance': balance,
    };
  }
}

class UserBalanceModel extends UserBalanceEntity {
  const UserBalanceModel({
    required super.bzc,
    required super.eur,
    required super.xaf,
    required super.diamond,
    required super.userCurrencyBalance,
    required super.userCurrency,
    required super.userCurrencyCode,
    required super.financialWalletNumber,
    required super.beatzcoinWalletNumber,
    super.paymentAccount,
    super.revenueAccount,
    super.beatzcoinAccount,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const {};

    return UserBalanceModel(
      bzc: JsonParsingUtils.parseDouble(data['BZC']),
      eur: JsonParsingUtils.parseDouble(data['EUR']),
      xaf: JsonParsingUtils.parseDouble(data['XAF']),
      diamond: JsonParsingUtils.parseDouble(data['DIAMOND']),
      userCurrencyBalance:
          JsonParsingUtils.parseDouble(data['user_currency_balance']),
      userCurrency: JsonParsingUtils.parseString(data['user_currency']),
      userCurrencyCode:
          JsonParsingUtils.parseString(data['user_currency_code']),
      financialWalletNumber:
          JsonParsingUtils.parseString(data['financial_wallet_number']),
      beatzcoinWalletNumber:
          JsonParsingUtils.parseString(data['beatzcoin_wallet_number']),
      // ---- objets imbriqués, jamais de crash même si absents ----
      paymentAccount: data['payment_account'] != null
          ? PaymentAccountModel.fromJson(
              JsonParsingUtils.parseMap(data['payment_account']),
            )
          : null,
      revenueAccount: data['revenue_account'] != null
          ? RevenueAccountModel.fromJson(
              JsonParsingUtils.parseMap(data['revenue_account']),
            )
          : null,
      beatzcoinAccount: data['beatzcoin_account'] != null
          ? BeatzcoinAccountModel.fromJson(
              JsonParsingUtils.parseMap(data['beatzcoin_account']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BZC': bzc,
      'EUR': eur,
      'XAF': xaf,
      'DIAMOND': diamond,
      'user_currency_balance': userCurrencyBalance,
      'user_currency': userCurrency,
      'user_currency_code': userCurrencyCode,
      'financial_wallet_number': financialWalletNumber,
      'beatzcoin_wallet_number': beatzcoinWalletNumber,
      if (paymentAccount is PaymentAccountModel)
        'payment_account': (paymentAccount as PaymentAccountModel).toJson(),
      if (revenueAccount is RevenueAccountModel)
        'revenue_account': (revenueAccount as RevenueAccountModel).toJson(),
      if (beatzcoinAccount is BeatzcoinAccountModel)
        'beatzcoin_account':
            (beatzcoinAccount as BeatzcoinAccountModel).toJson(),
    };
  }
}

// import '../../domain/entities/user_balance_entity.dart';

// class UserBalanceModel extends UserBalanceEntity {
//   const UserBalanceModel({
//     required super.bzc,
//     required super.eur,
//     required super.xaf,
//     required super.diamond,
//     required super.userCurrencyBalance,
//     required super.userCurrency,
//     required super.userCurrencyCode,
//     required super.financialWalletNumber,
//     required super.beatzcoinWalletNumber,
//   });

//   factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
//     return UserBalanceModel(
//       bzc: double.parse(json['BZC'].toString()),
//       eur: double.parse(json['EUR'].toString()),
//       xaf: double.parse(json['XAF'].toString()),
//       diamond: double.parse(json['DIAMOND'].toString()),
//       userCurrencyBalance:
//           double.parse(json['user_currency_balance'].toString()),
//       userCurrency: json['user_currency'].toString(),
//       userCurrencyCode: json['user_currency_code'].toString(),
//       financialWalletNumber: json['financial_wallet_number'].toString(),
//       beatzcoinWalletNumber: json['beatzcoin_wallet_number'].toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'BZC': bzc,
//       'EUR': eur,
//       'XAF': xaf,
//       'DIAMOND': diamond,
//       'user_currency_balance': userCurrencyBalance,
//       'user_currency': userCurrency,
//       'user_currency_code': userCurrencyCode,
//       'financial_wallet_number': financialWalletNumber,
//       'beatzcoin_wallet_number': beatzcoinWalletNumber,
//     };
//   }
// }
