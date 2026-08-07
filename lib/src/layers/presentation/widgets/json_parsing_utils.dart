class JsonParsingUtils {
  JsonParsingUtils._();

  /// Parse un double de façon sûre, retourne [fallback] si null/invalide.
  static double parseDouble(dynamic value, {double fallback = 0}) {
    if (value == null) return fallback;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  /// Parse une string de façon sûre, retourne [fallback] si null.
  static String parseString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  /// Extrait une Map de façon sûre, retourne une Map vide si absent/invalide.
  static Map<String, dynamic> parseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }
}
