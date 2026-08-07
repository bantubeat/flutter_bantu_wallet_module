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
      "postal_code": "Postal code",
      "try_again": "Try again",
      "all_fields_required": "All fields are required",
      "field_required": "The {{field}} field is required",
      "iban": "IBAN",
      "swift_code": "BIC/Swift Code",
      "bank_name": "Bank Name",
      "gsm_number": "GSM Number",
      "operator": "Operator",
      "read_and_approved": "Read and Approved",
      "copied": "ID copied",
      "account_id": "ACCOUNT ID: {{id}}",
      "current_balance": "Current balance",
      "see_all": "See all",
      "today": "TODAY",
      "previous": "PREVIOUS",
      "credited": "CREDITED",
      "successful": "SUCCESS",
      "no_transaction": "No transaction",
      "tx_deposit": "Deposit",
      "tx_debit": "Debit",
      "tx_credit": "Credit",
      "tx_withdrawal": "Withdrawal",
      "tx_internal_in": "Internal incoming",
      "tx_internal_out": "Internal outgoing",
      "amount": "Amount",
      "tokens": "Tokens",
      "payment_method": "Payment method",
      "service": "Service",
      "fees": "Fees",
      "close": "Close",
      "positive_amount_error": "The amount must be a positive number",
      "purchase_history": "Purchase history",
      "print": "Print"
    },
    "image_service": {"choose_camera": "Camera", "choose_gallery": "Gallery"},
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
          "Please note that the transfer fees from your payment account are your responsibility and you agree to pay income taxes in your country of residence.",
      "description1":
          "Note: Payment requests can be made at any time. Please allow an average of 15 days for the funds to be received in your account.",
      "description2":
          "In accordance with European Union laws, we must verify your identity before any payment. See ",
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
        "description":
            "To validate the registration of your payment account, you must enter the code that was sent to you by email.",
        "code_placeholder": "Enter the code",
        "resend_code": "Resend code"
      }
    },
    "withdrawal_process": {
      "request_title": "Slip N° : {{id}}",
      "fees_warning1":
          "Please note that the transfer fees from your payment account are your responsibility and you agree to pay income taxes in your country of residence. See ",
      "fees_warning2":
          "Bantubeat terms of use, policy, and Bantubeat payment conditions.",
      "amount_to_withdraw_in_eur": "Amount to withdraw in €",
      "insufficient_funds": "Insufficient balance for this withdrawal",
      "resume_description1": "I, the undersigned ",
      "resume_description2":
          ", acting as the holder/representative of account ",
      "resume_description3": ", request the payment of the sum of ",
      "resume_description4": " to my registered payment preference account:",
      "use_my_bank_account": "Use my bank account",
      "use_my_mobile_account": "Use my Mobile Money account",
      "i_acceptes_fees":
          "I accept and acknowledge that transaction fees will be my responsibility, deducted from the requested amount.",
      "place_and_date1": "Done at \"",
      "place_and_date2": "\" On \"",
      "place_and_date3": "\"",
      "signature1": "Signature: \"",
      "signature2": "\"",
      "otp_code": {
        "title": "Verification code",
        "description":
            "To validate your payment request, you must enter the code that was sent to you by email"
      },
      "eligibility": {
        "eligible": "You are eligible to make a withdrawal",
        "pendingWithdrawal":
            "You already have a withdrawal request being processed. You cannot make a new request.",
        "alreadyMadeWithdrawal":
            "You have already made a withdrawal this month",
        "invalidRequestPeriod":
            "Withdrawal requests must be made between the 25th and 30th of the month",
        "kycNotValidated":
            "Your KYC has not yet been validated. You cannot make a withdrawal until your KYC is validated.",
        "unknownError":
            "An error occurred while checking your withdrawal eligibility. Please try again later."
      },
      "status": {
        "successfullyCreated": "Withdrawal request created successfully",
        "badOrExpiredPaymentSlip":
            "The withdrawal slip is invalid or has expired",
        "kycNotValidated": "Your KYC has not yet been validated",
        "paymentPreferenceNotFound": "No payment method registered",
        "insufficientBalance": "Insufficient balance for this withdrawal",
        "requestConflict":
            "You already have a withdrawal request being processed",
        "badOrExpiredOTPCode": "The OTP code is invalid or has expired",
        "invalidRequestPeriod":
            "Withdrawal requests must be made between the 25th and 30th of the month",
        "unknownError":
            "An error occurred while creating your withdrawal request"
      }
    },
    "featlink_home_page": {
      "title": "Featlink Wallet",
      "subtitle": "Centralize your payments and Featlink earnings",
      "account_management": "ACCOUNT MANAGEMENT",
      "estimated_revenue": "YOUR ESTIMATED REVENUE",
      "sales": "SALES",
      "tips": "TIPS",
      "gifts": "GIFTS",
      "earn_with_featlink": "EARN WITH FEATLINK",
      "saloonprived_description":
          "Sell exclusive content, receive gifts and tips",
      "chat_description": "Earn via DialPay, SwipePay and gifts",
      "liberty_description": "Receive gifts",
      "servicepro_description":
          "Sell your services & products: Ads, Tickets, Content access",
      "menu_billing": "Billing and payment",
      "menu_billing_description":
          "Top up your account and enjoy all Featlink features",
      "menu_monetization": "Monetization",
      "menu_monetization_description": "View your earnings and convert",
      "menu_beatzcoins_description": "Buy and use your tokens",
      "menu_history": "Transaction history",
      "menu_history_description": "Track all your operations",
      "help_center": "HELP CENTER"
    },
    "monetization_page": {
      "title": "Monetization",
      "subtitle": "MANAGE YOUR EARNINGS AND CONVERSIONS",
      "revenue_account": "Revenue Account",
      "digital_assets": "YOUR DIGITAL ASSETS",
      "history": "HISTORY",
      "see_all": "SEE ALL",
      "estimated_balance": "ESTIMATED BALANCE",
      "collect_earnings": "COLLECT YOUR EARNINGS",
      "add_settlement_account": "ADD A SETTLEMENT ACCOUNT",
      "kyc_verified": "KYC VERIFIED",
      "kyc_to_verify": "KYC TO VERIFY",
      "monetization_restricted": "Restricted monetization",
      "monetization_restricted_description":
          "limited monetization on your account. Discover the Featlink monetization program.",
      "kyc_required": "KYC REQUIRED",
      "kyc_required_description":
          "Proceed with identity verification to start collecting your earnings",
      "program_title": "Featlink Monetization Program",
      "program_description":
          "Learn everything about monetization and how to generate more income in the Featlink ecosystem",
      "settlement_account": "Settlement Account",
      "settlement_account_description":
          "Your payment requests will be paid to the following payment method: {{account}}",
      "diamonds": "DIAMONDS",
      "stars": "STARS",
      "diamond_rate": "1 diamond = {{rate}} FCFA",
      "stars_rate": "{{count}} stars = 1 diamond",
      "estimated_value": "Estimated value\nDigital Assets",
      "convert": "CONVERT",
      "country_with_currency": "{{country}} ({{currency}})",
      "secure_transactions": "Secure transactions",
      "delay_info":
          "Usual delay: On average 15 days to receive funds in your account"
    },
    "payment_success_page": {
      "title": "Payment successful",
      "message":
          "Your payment has been processed successfully. You can now fully enjoy the Featlink features",
      "vat_rate": "VAT ({{rate}}%)",
      "download_receipt": "Download Receipt",
      "generating_receipt": "Generating receipt…",
      "support_help": "Need help? Contact our support team at\n"
    },
    "monetization_program": {
      "app_title": "MONETIZATION",
      "app_subtitle": "TURN YOUR INTERACTIONS INTO VALUE",
      "about": "About",
      "about_text1":
          "FeatLink is a super app designed to reward your engagement. Earn ",
      "about_diamonds": "Diamonds",
      "about_text2": " through your interactions, convert them into ",
      "about_gains": "Earnings",
      "about_text3":
          " via your wallet and withdraw your funds safely after verifying your identity (KYC).",
      "secure_certified": "SECURE & CERTIFIED",
      "how_title": "How it works",
      "how_tag": "PROCESS",
      "step1_title": "Content, article, ticket…",
      "step1_description":
          "Use our dedicated services to sell your content, products, event tickets and receive your earnings directly in your wallet.",
      "step2_title": "Earn Diamonds",
      "step2_description":
          "Use our exclusive tools to accumulate diamonds during your daily interactions.",
      "step3_title": "Convert to Earnings",
      "step3_description":
          "Go to Wallet > Monetization to turn your diamonds into money.",
      "step4_title": "Withdraw",
      "step4_description":
          "Submit a withdrawal request. After compliance checks, receive your funds via mobile money or bank transfer.",
      "tools_title": "Explore the tools",
      "tools_tag": "SOURCES",
      "chat_title": "Featlink Chat",
      "chat_description": "Earn via DialPay, SwipePay and gifts",
      "saloonprived_title": "SaloonPrived",
      "saloonprived_description": "Sell exclusive content, receive gifts and tips",
      "liberty_title": "Liberty",
      "liberty_description": "Receive gifts",
      "service_pro_title": "Service Pro",
      "service_pro_description":
          "Sell your services & products: Ads, Tickets, Content access",
      "see_restrictions": "VIEW RESTRICTIONS",
      "rules_sanctions": "RULES & SANCTIONS",
      "reward_diamonds": "REWARD: DIAMONDS",
      "tools_monetization": "Monetization\ntools",
      "secure_compliant": "SECURE & COMPLIANT",
      "exclusive_content_sale": "Exclusive content sales",
      "subscriptions_access_ppv": "Subscriptions, access, PPV",
      "receive_gains_when_fans_buy":
          "RECEIVE YOUR EARNINGS WHEN FANS BUY ACCESS",
      "tips": "Tips",
      "receive_tips": "Receive tips",
      "gifts": "Gifts",
      "receive_gifts": "Receive gifts",
      "good_practices": "BEST PRACTICES",
      "practice1_title": "Post regularly",
      "practice1_description":
          "Consistency is the key to keeping your community engaged.",
      "practice2_title": "Respect content rules",
      "practice2_description":
          "Make sure your posts comply with SaloonPrivé standards.",
      "creator_guide": "VIEW THE CREATOR GUIDE\nSALOONPRIVED",
      "saloonprived": "SALOONPRIVED",
      "saloonprived_monetize": "MONETIZE YOUR CONTENT",
      "saloonprived_label": "SALOONPRIVÉ",
      "chat_monetize": "MONETIZE YOUR CONVERSATIONS",
      "chat_hero": "Optimize your\ninteractions.",
      "chat_intro":
          "Discover tools designed to reward your time and engagement within the FeatLink community.",
      "active": "ACTIVE",
      "standard": "STANDARD",
      "unlimited": "UNLIMITED",
      "dialpay_title": "DialPay",
      "dialpay_description": "Answer priority messages.",
      "dialpay_note": "You earn Diamonds when you accept and answer",
      "swippay_title": "SwipePay",
      "swippay_description": "Priority likes.",
      "swippay_note":
          "You earn Diamonds if you like back a person who sent you a priority like (anti-abuse conditions)",
      "gifts_chat_description": "Receive gifts in the chat.",
      "gifts_note": "Every gift you receive earns you Diamonds",
      "engine_label": "FEATLINK MONETIZATION ENGINE",
      "liberty_gifts_description":
          "Receive gifts via the Liberty chat and earn Diamonds.",
      "more_tools_soon": "More tools are coming soon.",
      "services_pro": "Services Pro",
      "profil_pro_required": "PRO PROFILE REQUIRED",
      "service_pro_label": "SERVICE PRO",
      "monetize_expertise": "Monetize your expertise",
      "content_sale": "Content sales",
      "items_sale": "Selling items & goods",
      "items_sale_description": "Products and Pro offers (according to authorized categories)",
      "gifts_conversation_description":
          "Receive gifts through your conversations in the chat.",
      "diamonds": "DIAMONDS",
      "banner_text": "Increase your income with our\nexpert tools",
      "restrictions_title": "Monetization restrictions",
      "restrictions_heading": "Monetization\nrestrictions",
      "safety_center": "FEATLINK SAFETY CENTER",
      "country_not_eligible": "Country not eligible",
      "country_not_eligible_description":
          "Monetization is only available in eligible countries.",
      "see_eligible_countries": "See the list of eligible countries",
      "policy_violation": "FeatLink policy violation",
      "policy_violation_description":
          "In case of abuse, fraud, harassment or circumvention, access to monetization may be suspended.",
      "non_compliant_content": "Non-compliant content",
      "non_compliant_content_description":
          "Some content is prohibited. Non-compliant content may be removed and lead to sanctions.",
      "understand_sanctions": "Understand the sanctions",
      "sanctions_title": "Monetization sanctions",
      "sanctions_heading": "Understand\ncompliance",
      "sanctions_intro":
          "We value your talent. Discover the gradual steps to maintain a healthy and secure ecosystem.",
      "sanction_level1_title": "Warning",
      "sanction_level1_description":
          "A simple reminder of our rules. Nothing is impacted, we are here to guide you.",
      "sanction_level2_title": "Temporary restriction",
      "sanction_level2_description":
          "A short break of a few days to adjust your content. Your account stays active.",
      "sanction_level3_title": "Monetization suspension",
      "sanction_level3_description":
          "Earnings are paused. An opportunity to review your compliance strategy together.",
      "sanction_level4_title": "Collection blocked (investigation/KYC)",
      "sanction_level4_description":
          "A standard security check to protect your funds during an in-depth review.",
      "sanction_level5_title": "Permanent removal (serious cases)",
      "sanction_level5_description":
          "Last resort for repeated violations. We prefer to act together before it gets to that.",
      "request_lift": "Request restriction lift",
      "lift_heading": "Dispute Center",
      "lift_heading_description":
          "Fill out this form to submit your case to our compliance team.",
      "motif_label": "Reason for dispute",
      "select_motif": "Select a reason",
      "motif_wrongly_suspended": "Account wrongly suspended",
      "motif_kyc_error": "KYC verification error",
      "motif_misidentified_content": "Misidentified content",
      "motif_other": "Other",
      "situation_label": "Explain your situation",
      "situation_hint": "Describe the facts precisely...",
      "evidence_label": "Attach proof / screenshot",
      "click_to_upload": "Click to upload",
      "upload_formats": "PNG, JPG or PDF (Max. 5MB)",
      "requests_handled_24h": "Requests are handled within 24–72h",
      "false_declaration_warning":
          "Any false declaration may extend the sanction or lead to the permanent suspension of your account.",
      "send_request": "Send request",
      "secure_infrastructure": "SECURE INFRASTRUCTURE",
      "form_required": "Please complete the form.",
      "request_sent": "Request sent.",
      "eligible_title": "Eligible countries",
      "eligible_intro":
          "Discover the countries and regions where the FeatLink monetization program is currently available.",
      "search_country": "Search a country...",
      "available": "AVAILABLE",
      "no_country_found": "No country found.",
      "load_error": "Unable to load eligible countries.",
      "retry": "Retry"
    }
  }
};
