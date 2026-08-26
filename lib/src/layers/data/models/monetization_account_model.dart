class MonetizationAccountModel {
  final String uuid;
  final String accountType;
  final String fiscalIdNumber;
  final String documentUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MonetizationAccountModel({
    required this.uuid,
    required this.accountType,
    required this.fiscalIdNumber,
    required this.documentUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MonetizationAccountModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value, {String defaultValue = ''}) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return MonetizationAccountModel(
      uuid: parseString(json['uuid']),
      accountType: parseString(json['account_type']),
      fiscalIdNumber: parseString(json['fiscal_id_number']),
      documentUrl: parseString(json['document_url']),
      status: parseString(json['status']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  bool get isApproved => status.toLowerCase() == 'approved';
}
