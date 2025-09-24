// ignore_for_file: prefer_single_quotes, require_trailing_commas, avoid_escaping_inner_quotes

const Map<String, dynamic> langMap = {
  "wallet_module": {
    "appBarTitle": "Wallet",
    "common": {
      "initializing": "Initializing...",
      "an_error_occur": "An error occurred: {{message}}",
      "insufficient_funds": "Insufficient funds",
      "all": "All",
      "buy": "Pay",
      "cancel": "Cancel",
      "validate": "Validate",
      "save": "Save",
      "country": "Country",
      "upload": "Upload",
			"first_name": "First name",
			"last_name": "Last name",
			"birthdate": "Birthdate",
			"street": "Street",
			"city": "City",
			"postal_code": "Code postal",
      "try_again": "Try again",
			"all_fields_required": "All fields are required",
			"field_required": "The {{field}} field is required",
      "iban": "IBAN",
      "swift_code": "BIC/Swift Code",
      "bank_name": "Bank Name",
      "gsm_number": "GSM Number",
      "operator": "Operator",
      "read_and_approved": "Read and Approved"
    },
    "image_service": {
			"choose_camera": "Camera",
			"choose_gallery": "Gallery"
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
			"description": "Please note that the transfer fees from your payment account are your responsibility and you agree to pay income taxes in your country of residence.",
			"description1": "Note: Payment requests can be made at any time. Please allow an average of 15 days for the funds to be received in your account.",
			"description2": "In accordance with European Union laws, we must verify your identity before any payment. See ",
			"description3": "Bantubeat payment policy and conditions",
			"financial_account_balance": "Your Financial account balance",
      "see_details": "See details",
      "Your_registered_payment_account": "Your registered payment account:",
      "request_payment": "Request a payment",
			"check_your_identity": "Check your identity",
			"add_a_payment_method": "Add a payment method",
			"you_can_receive_payment_yet": "You cannot receive payment yet."
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
    },
    "payment_account": {
			"title": "Payment Account",
      "description":
          "Please choose and enter the details of your payment account to which you wish to receive your payments",
      "account_type": "Account type",
      "mobile_operator_name": "Mobile operator name",
      "account_number": "Account number",
			"confirm_account_number": "Confirm account number",
			"bank_name": "Bank name",
			"swift_code": "Swift Code",
      "account_holder": "Account holder",
      "load_bank_docs": "Upload a bank document/card",
			"mobile_payment": "Mobile Payment",
			"mobile_payment_way": "Instantly",
			"bank_account": "Bank Account",
			"bank_account_way": "Bank transfer",
			"bad_account_number_confirmation": "Bad account number confirmation",
			"invalid_phone_number": "Invalid phone number",
			"modal": {
				"title": "Verification code",
				"description": "To validate the registration of your payment account, you must enter the code that was sent to you by email.",
				"code_placeholder": "Enter the code",
				"resend_code": "Resend code"
			}
    },
		"withdrawal_process": {
      "request_title": "Slip N° : {{id}}",
      "fees_warning1": "Please note that the transfer fees from your payment account are your responsibility and you agree to pay income taxes in your country of residence. See ",
      "fees_warning2": "Bantubeat terms of use, policy, and Bantubeat payment conditions.",
      "amount_to_withdraw_in_eur": "Amount to withdraw in €",
      "insufficient_funds": "Insufficient balance for this withdrawal",
      "resume_description1": "I, the undersigned ",
      "resume_description2": ", acting as the holder/representative of account ",
      "resume_description3": ", request the payment of the sum of ",
      "resume_description4": " to my registered payment preference account:",
      "use_my_bank_account": "Use my bank account",
      "use_my_mobile_account": "Use my Mobile Money account",
      "i_acceptes_fees": "I accept and acknowledge that transaction fees will be my responsibility, deducted from the requested amount.",
      "place_and_date1": "Done at \"",
      "place_and_date2": "\" On \"",
      "place_and_date3": "\"",
      "signature1": "Signature: \"",
      "signature2": "\"",
			"otp_code": {
				"title": "Verification code",
				"description": "To validate your payment request, you must enter the code that was sent to you by email"
			},
			"eligibility": {
				"eligible": "You are eligible to make a withdrawal",
				"pendingWithdrawal": "You already have a withdrawal request being processed. You cannot make a new request.",
				"alreadyMadeWithdrawal": "You have already made a withdrawal this month",
				"invalidRequestPeriod": "Withdrawal requests must be made between the 25th and 30th of the month",
				"kycNotValidated": "Your KYC has not yet been validated. You cannot make a withdrawal until your KYC is validated.",
				"unknownError": "An error occurred while checking your withdrawal eligibility. Please try again later."
			},
			"status": {
				"successfullyCreated": "Withdrawal request created successfully",
				"badOrExpiredPaymentSlip": "The withdrawal slip is invalid or has expired",
				"kycNotValidated": "Your KYC has not yet been validated",
				"paymentPreferenceNotFound": "No payment method registered",
				"insufficientBalance": "Insufficient balance for this withdrawal",
				"requestConflict": "You already have a withdrawal request being processed",
				"badOrExpiredOTPCode": "The OTP code is invalid or has expired",
				"invalidRequestPeriod": "Withdrawal requests must be made between the 25th and 30th of the month",
				"unknownError": "An error occurred while creating your withdrawal request"
			}
    }
  }
};
