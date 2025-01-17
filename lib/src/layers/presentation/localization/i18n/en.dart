// ignore_for_file: prefer_single_quotes, require_trailing_commas

const Map<String, dynamic> langMap = {
  "wallet_module": {
    "appBarTitle": "Wallet",
    "common": {
      "initializing": "Initializing...",
      "an_error_occur": "An error occurred: {{message}}",
      "insufficient_funds": "Insufficient funds",
      "all": "All",
      "buy": "Pay",
      "cancel": "Cancel"
    },
    "home_page": {
      "title": "My Balance",
      "deposit": "Deposit",
      "wallet": "Wallet",
      "withdrawal": "Withdrawal",
      "beatzcoins": "Beatzcoins",
      "transactions_history": "Transaction history"
    },
    "wallets_page": {
      "title": "Wallet",
      "description":
          "In your wallet, you have a financial account that displays your account balance in monetary value and a Beatzcoin account that displays your Beatzcoin balance. All payments made on the platform are made with your Beatzcoin tokens. To make a purchase on the platform, you must first fund your financial account.\nIf the balance of your Beatzcoin account does not cover the full amount of the renewals, your platform access will be canceled. Learn more about the ",
      "description2": "Bantubeat payment policy and conditions",
      "financier_account": {
        "title": "Financial Account",
        "description":
            "Your financial account allows you to purchase tokens and also records the amount of resale of your tokens earned on all Bantubeat platforms.",
        "request_payment": "Request a payment",
        "add_funds": "Add funds"
      },
      "beatzcoin_account": {
        "title": "Beatzcoin Account",
        "description1":
            "Your Beatzcoin account allows you to make purchases on all Bantubeat platforms.",
        "description2":
            "You can exchange your tokens, the equivalent amount will be deposited into your financial account.",
        "description3":
            "Please note that when you exchange your Beatzcoin tokens, fees and taxes are deducted. See the ",
        "description4": "Bantubeat payment policy and conditions.",
        "minimum_bzc": "minimum {{min_quantity}} BZC",
        "exchange": "Exchange",
        "exchange_successful": "Beatzcoins exchanged successfully!"
      }
    },
    "deposit_page": {
      "title": "Choose your payment method",
      "payment_zone_africa": "AFRICA\nMobile Money, Card",
      "payment_zone_other": "Others",
      "choose_currency": "Choose your Currency",
      "credit_or_visa_card": "Credit or VISA card",
      "amount": "Amount {{amount}}",
      "price": "Price:",
      "fees": "Fees ({{percent}}% operator and service fees):",
      "total": "Total due:",
      "continue_payment": "Continue payment",
      "amount_and_currency_required": "Amount and/or currency is required",
      "payment_done_check_account": "Payment completed, check your balance",
      "warning1_your_recharge":
          "Your recharge may be subject to additional fees due to Google's commission.",
      "warning2_link": "Terms and Conditions",
      "warning3_and": " and ",
      "warning4_link": "privacy policy",
      "warning5_google_play":
          " of Bantubeat apply. Google Play may also ask you to accept additional terms."
    },
    "withdrawal_page": {
      "title": "Withdrawal",
      "description":
          "Payment requests are made through your Bantubeat profile. Log in to your Bantubeat Account, then go to your Balance and then Withdrawal.\nYou must register a payment method to which your payment requests will be transferred, you can modify your payment preferences at any time.\nN.B. You can only make 1 withdrawal per month. All payment requests must be made between the 25th and 30th of the month. Allow an average of 15 days for the funds to be received in your account.\nIn accordance with European Union laws, we must verify your identity before any payment.",
      "financial_account_balance": "Your Financial account balance",
      "see_details": "See details",
      "Your_registered_payment_account": "Your registered payment account:",
      "request_payment": "Request a payment"
    },
    "beatzcoins_page": {
      "title":
          "Buy Beatzcoins to enjoy premium features of the platform and other Bantubeat applications",
      "description":
          "The Beatzcoin is a token that we are launching to allow our users to fully enjoy the Bantubeat applications. The Beatzcoin is available and usable only on Bantubeat and its applications. Each user who holds a stock of Beatzcoins can exchange them for a Bantubeat payment. The corresponding amount, less taxes and service fees, will be credited to your financial account.",
      "description2": "\nSee the",
      "description3": "terms and conditions of purchase and use of Beatzcoins",
      "bzc_account_balance": "Your Beatzcoin account balance",
      "see_details": "See details",
      "buy_bzc": "Buy BZC"
    },
    "buy_beatzcoins_page": {
      "my_balance": "My balance",
      "custom_load": "Custom load",
      "enter_quantity": "Enter the Quantity",
      "ttc_amount_in": "TTC amount in {{amount}}",
      "load": "Load",
      "min_fiat_amount": "Minimum {{amount}} BZC",
      "modal": {
        "title": "Purchase of coins",
        "amount_of_your_load": "Amount of your load",
        "ttc_price": "TTC price {{price}}",
        "buy_with": "Pay with",
        "bantubeat_balance": "Bantubeat balance",
        "add_funds": "Add funds",
        "insufficient_funds":
            "Your account balance is insufficient to make this purchase",
        "warning1":
            "*The price on the Google Play Store and Apple Store may vary due to Google and Apple commissions",
        "warning2a": "By continuing, you accept ",
        "warning2b": "the purchase and use policy of Beatzcoins"
      }
    },
    "transaction_history_page": {
      "title": "Wallet history",
      "financial_account": "Financial\naccount",
      "beatzocoin_account": "Beatzcoin\naccount",
      "account": "Account",
      "table": {
        "caption": "Transaction Details",
        "transaction_id": "Transaction ID",
        "transaction_ref": "Reference",
        "date": "Date",
        "old_balance": "Previous balance",
        "new_balance": "New balance",
        "amount": "Amount",
        "input_amount": "Entered amount",
        "bzc_quantity": "BZC quantity",
        "status": "Status",
        "type": "Type",
        "description": "Description",
        "payment_method": "Operator"
      },
      "status": {
        "FAILED": "Failed",
        "SUCCESS": "Success",
        "PENDING": "Pending"
      },
      "type": {
        "DEPOSIT": "Deposit",
        "WITHDRAWAL": "Withdrawal",
        "INTERNAL_IN": "Expense",
        "INTERNAL_OUT": "Purchase",
        "INTERNAL_IN_bzc": "BZC purchase",
        "INTERNAL_OUT_bzc": "BZC sale"
      }
    }
  }
};
