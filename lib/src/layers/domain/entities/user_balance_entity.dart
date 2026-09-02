import 'package:equatable/equatable.dart';

// ---- payment_account ----
class PaymentAccountEntity extends Equatable {
  final String walletNumber;
  final double balanceEur;
  final String userCurrency;
  final String userCurrencyCode;
  final double userCurrencyBalance;

  const PaymentAccountEntity({
    required this.walletNumber,
    required this.balanceEur,
    required this.userCurrency,
    required this.userCurrencyCode,
    required this.userCurrencyBalance,
  });

  @override
  List<Object?> get props => [
        walletNumber,
        balanceEur,
        userCurrency,
        userCurrencyCode,
        userCurrencyBalance,
      ];
}

// ---- revenue_account.sub_accounts.{diamonds|stars} ----
class RevenueSubAccountEntity extends Equatable {
  final String accountNumber;
  final double balance;

  const RevenueSubAccountEntity({
    required this.accountNumber,
    required this.balance,
  });

  @override
  List<Object?> get props => [accountNumber, balance];
}

// ---- revenue_account ----
class RevenueAccountEntity extends Equatable {
  final String walletNumber;
  final double balanceEur;
  final String userCurrency;
  final String userCurrencyCode;
  final double userCurrencyBalance;
  final RevenueSubAccountEntity diamonds;
  final RevenueSubAccountEntity stars;

  const RevenueAccountEntity({
    required this.walletNumber,
    required this.balanceEur,
    required this.userCurrency,
    required this.userCurrencyCode,
    required this.userCurrencyBalance,
    required this.diamonds,
    required this.stars,
  });

  @override
  List<Object?> get props => [
        walletNumber,
        balanceEur,
        userCurrency,
        userCurrencyCode,
        userCurrencyBalance,
        diamonds,
        stars,
      ];
}

// ---- beatzcoin_account ----
class BeatzcoinAccountEntity extends Equatable {
  final String walletNumber;
  final double balance;

  const BeatzcoinAccountEntity({
    required this.walletNumber,
    required this.balance,
  });

  @override
  List<Object?> get props => [walletNumber, balance];
}

class UserBalanceEntity extends Equatable {
  // ---- Champs existants (payment_account / beatzcoin_account) ----
  final String beatzcoinWalletNumber;
  final double bzc;
  final String financialWalletNumber;
  final double eur;
  final String userCurrency;
  final String userCurrencyCode;
  final double userCurrencyBalance;
  final double diamond;
  final double xaf;

  // ---- Nouveaux champs : revenue_account ----
  final String revenueWalletNumber;
  final double revenueBalanceEur;
  final double revenueUserCurrencyBalance;

  // ---- Nouveaux champs : revenue_account.sub_accounts.diamonds ----
  final String diamondAccountNumber;

  // ---- Nouveaux champs : revenue_account.sub_accounts.stars ----
  final String starsAccountNumber;
  final double stars;

  // ================================================================
  // ---- AJOUT : objets structurés complets (nullable) ----
  final PaymentAccountEntity? paymentAccount;
  final RevenueAccountEntity? revenueAccount;
  final BeatzcoinAccountEntity? beatzcoinAccount;
  // ================================================================

  const UserBalanceEntity({
    required this.beatzcoinWalletNumber,
    required this.bzc,
    required this.financialWalletNumber,
    required this.eur,
    required this.userCurrency,
    required this.userCurrencyCode,
    required this.userCurrencyBalance,
    required this.diamond,
    required this.xaf,
    this.revenueWalletNumber = '',
    this.revenueBalanceEur = 0,
    this.revenueUserCurrencyBalance = 0,
    this.diamondAccountNumber = '',
    this.starsAccountNumber = '',
    this.stars = 0,
    this.paymentAccount,
    this.revenueAccount,
    this.beatzcoinAccount,
  });

  @override
  List<Object?> get props => [
        beatzcoinWalletNumber,
        bzc,
        financialWalletNumber,
        eur,
        userCurrency,
        userCurrencyCode,
        userCurrencyBalance,
        diamond,
        xaf,
        revenueWalletNumber,
        revenueBalanceEur,
        revenueUserCurrencyBalance,
        diamondAccountNumber,
        starsAccountNumber,
        stars,
        paymentAccount,
        revenueAccount,
        beatzcoinAccount,
      ];
}
