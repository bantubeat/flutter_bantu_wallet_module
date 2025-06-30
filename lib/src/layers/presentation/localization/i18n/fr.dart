// ignore_for_file: prefer_single_quotes, require_trailing_commas

const Map<String, dynamic> langMap = {
  "wallet_module": {
    "appBarTitle": "Porte-Feuille",
    "common": {
      "initializing": "Initialisation...",
      "an_error_occur": "An error occur: {{message}}",
      "insufficient_funds": "Solde insuffisant",
      "all": "Tout",
      "buy": "Payer",
      "cancel": "Annuler"
    },
    "home_page": {
      "title": "Ma Balance",
      "deposit": "Dépôt",
      "wallet": "Porte Feuille",
      "withdrawal": "Retrait",
      "beatzcoins": "Beatzcoins",
      "transactions_history": "Historiques des transactions"
    },
    "wallets_page": {
      "title": "Porte-Feuille",
      "description":
          "Dans votre porte-feuille, vous disposez d'un compte financier qui affiche en valeur monétaire le solde de votre compte et un compte de beatzcoin qui affiche le solde de vos beatzcoins. Tous les paiements effectués sur la plateforme se font par vos jetons beatzcoin. Pour effectuer un achat sur la plateforme vous devez au préalable approvisionner votre compte financier.\nSi le solde de votre compte Beatzcoin ne couvre pas la totalité du montant des renouvellements, Votre accès à la plateforme sera annulé. En savoir plus sur la",
      "description2": " politique et condition de paiement Bantubeat",
      "financier_account": {
        "title": "Compte Financier",
        "description":
            "Votre compte financier vous permet d'acheter les jetons et enregistre également le montant de revente de vos jetons gagnés sur l'ensemble des plateformes bantubeat.",
        "request_payment": "Demander un paiement",
        "add_funds": "Ajouter des Fonds"
      },
      "beatzcoin_account": {
        "title": "Compte Beatzocoin",
        "description1":
            "Votre compte Beatzcoin vous permet d'effectuer des achats sur l'ensemble des plateformes bantubeat.",
        "description2":
            "Vous pouvez échanger vos jetons, le montant équivalent sera déposé sur votre compte financier.",
        "description3":
            "Attention, lorsque vous échangez vos jetons beatzcoin, les frais et taxes sont déduits. Voir la ",
        "description4": "Politique et conditions de paiement Bantubeat.",
        "minimum_bzc": "minimum {{min_quantity}} BZC",
        "exchange": "Echanger",
        "exchange_successful": "Beatzcoin échangés avec succès !"
      }
    },
    "deposit_page": {
      "title": "Choisissez votre méthode de paiement",
      "payment_zone_africa": "AFRIQUE\nMobile Money, Card",
      "payment_zone_other": "Autres",
      "choose_currency": "Choisissez votre Devise",
      "credit_or_visa_card": "Carte de crédit ou VISA",
      "amount": "Montant {{amount}}",
      "price": "Prix:",
      "fees": "Frais ({{percent}}% frais opérateur + services):",
      "total": "Total due:",
      "continue_payment": "Continuer le paiement",
      "amount_and_currency_required":
          "Le montant et/ou la devise sont obligatoires",
      "payment_done_check_account": "Paiement terminée, vérifier votre solde",
      "warning1_your_recharge":
          "Votre recharge peut être soumise à des frais supplémentaires en raison de la commission de Google.",
      "warning2_link": "Les conditions générales",
      "warning3_and": " et ",
      "warning4_link": "la politique de confidentialité",
      "warning5_google_play":
          " de Bantubeat s'appliquent. Google play peut également vous demander d'accepter des conditions supplémentaires."
    },
    "withdrawal_page": {
      "title": "Retrait",
      "description":
          "les demandes de paiement sont éffectuées via votre profil Bantubeat. Connectez vous sur votre Compte Bantubeat puis allez dans votre Balance et dans retrait.\nVous devez obligatoirement enregistrer un moyen de paiement sur lequel vos demandes de paiement seront transférées, vous pourriez modifier vos préférences de paiement à tout moment.\nN.B. Vous ne pouvez effectuer que 1 retrait par mois. Toutes les demandes de paiement doivent se faire entre le 25 et le 30 du mois. comptez en moyenne 15 jours pour la réception des fonds sur votre compte.\nConformément aux lois de l’union européenne, nous devons vérifier votre identité avant tout paiement.",
      "financial_account_balance": "Solde de votre compte Financier",
      "see_details": "Voir les détails",
      "Your_registered_payment_account": "Votre compte de paiement enregistré:",
      "request_payment": "Demander un paiement"
    },
    "beatzcoins_page": {
      "title":
          "Acheter des beatzcoins pour profiter des fonctionnalités premium de la plateforme et des autres applications Bantubeat",
      "description":
          "Le Beatzcoin est un jeton que nous mettons sur pied pour permettre à nos utilisateurs de profiter plainement des applications bantubeat. Le beatzcoin est disponible et utilisable uniquement sur bantubeat et ses applications. Chaque utilisateur qui détient un stock de beatzcoin peut les échanger contre un paiement de bantubeat. la somme correspondante, déduction des taxes et frais de service sera créditée sur votre compte financier.",
      "description2": "\nVoir les ",
      "description3": "les conditions d'achat et d'utilisation des Beatzcoins",
      "bzc_account_balance": "Solde de votre compte beatzcoin",
      "see_details": "Voir les détails",
      "buy_bzc": "Acheter des BZC"
    },
    "buy_beatzcoins_page": {
      "my_balance": "Mon solde",
      "custom_load": "Recharge personnalisée",
      "enter_quantity": "Entrez la Quantité",
      "ttc_amount_in": "Montant TTC en {{amount}}",
      "load": "Recharger",
      "min_fiat_amount": "Minimum {{amount}} BZC",
      "modal": {
        "title": "Achat de pièces",
        "amount_of_your_load": "Montant de ta recharge",
        "ttc_price": "Prix TTC {{price}}",
        "buy_with": "Payer avec",
        "bantubeat_balance": "Solde bantubeat",
        "add_funds": "Ajouter des Fonds",
        "insufficient_funds":
            "Le solde de votre compte est insuffisant pour effectuer cet achat",
        "warning1":
            "*Le prix sur Google play store et Apple store peuvent varier en raison de la commission de Google et Apple",
        "warning2a": "En continuant, tu acceptes ",
        "warning2b": "la politique d'achat et d'utilisation des beatzcoins"
      }
    },
    "transaction_history_page": {
      "title": "Historique portefeuille",
      "financial_account": "Compte\nFinancier",
      "beatzocoin_account": "Compte\nBeatzcoin",
      "account": "Compte",
      "table": {
        "caption": "Transaction Details",
        "transaction_id": "ID Transaction",
        "transaction_ref": "Référence",
        "date": "Date",
        "old_balance": "Solde avant",
        "new_balance": "Solde après",
        "amount": "Montant",
        "input_amount": "Montant entré",
        "bzc_quantity": "Quantité BZC",
        "status": "Statut",
        "type": "Type",
        "description": "Description",
        "payment_method": "Opérateur"
      },
      "status": {
        "FAILED": "Echec",
        "SUCCESS": "Succès",
        "PENDING": "En attente"
      },
      "type": {
        "DEPOSIT": "Dépôt",
        "WITHDRAWAL": "Retrait",
        "INTERNAL_IN": "Dépense",
        "INTERNAL_OUT": "Achat",
        "INTERNAL_IN_bzc": "Achat BZC",
        "INTERNAL_OUT_bzc": "Vente BZC"
      }
    }
  }
};
