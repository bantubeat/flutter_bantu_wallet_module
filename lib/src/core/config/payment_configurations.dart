// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// This file contain sample payment configurations that can be used with the
/// payment providers in this library.
///
/// Although payment configurations can be hardcoded in your application source
/// (as displayed in this example), we recommend you to keep this information in
/// a remote location that can be accessed from your application (e.g.: a
/// backend server). That way, you benefit from being able to use multiple
/// payment configurations that can be modified without the need to update your
/// application.
library;

import 'package:flutter_bantu_wallet_module/src/core/config/my_api_keys.dart';
import 'package:pay/pay.dart';

import 'my_app_env.dart';

/// Sample [PaymentConfiguration] for Apple Pay
PaymentConfiguration get defaultApplePayConfig =>
    PaymentConfiguration.fromJsonString(defaultApplePay);

/// Sample configuration for Apple Pay. Contains the same content as the file
/// under `assets/default_payment_profile_apple_pay.json`.
String get defaultApplePay => '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.sams.fish",
    "displayName": "Sam's Fish",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
  }
}''';

/// Sample [PaymentConfiguration] for Google Pay
PaymentConfiguration get defaultGooglePayConfig =>
    PaymentConfiguration.fromJsonString(defaultGooglePay);

/// Sample configuration for Google Pay. Contains the same content as the file
/// under `assets/default_payment_profile_google_pay.json`.
String get defaultGooglePay => '''{
  "provider": "google_pay",
  "data": {
    "environment": "${MyAppEnv.isProduction ? 'PRODUCTION' : 'TEST'}",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
						"gateway": "stripe",
  					"stripe:version": "2018-10-31",
						"stripe:publishableKey": "${MyApiKeys.stripePublishableKey}"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantName": "Bantubeat"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

String get basicGooglePayIsReadyToPay => '''{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
        }
      }
    ]
  }
}''';

String get basicGooglePayLoadPaymentData => '''{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "merchantInfo": {
      "merchantName": "Example Merchant"
    },
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "exampleGatewayMerchantId"
          }
        }
      }
    ],
    "transactionInfo": {
      "totalPriceStatus": "FINAL",
      "totalPrice": "12.34",
      "currencyCode": "USD"
    }
  }
}''';

String get invalidGooglePayIsReadyToPay => '''{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {}
      }
    ]
  }
}''';

String get invalidGooglePayLoadPaymentData => '''{
  "provider": "google_pay",
  "data": {
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "merchantInfo": {
      "merchantName": "Bantubeat"
    },
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["AMEX", "DISCOVER", "INTERAC", "JCB", "MASTERCARD", "VISA"]
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
						"gateway": "stripe",
  					"stripe:version": "2018-10-31",
						"stripe:publishableKey": "${MyApiKeys.stripePublishableKey}",
          }
        }
      }
    ],
    "transactionInfo": {
      "totalPriceStatus": "FINAL",
      "totalPrice": "#totalPrice#",
      "currencyCode": "USD"
    }
  }
}''';
