import 'dart:collection' show HashMap;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

/// Callback allowing to get the language path according to the specified locale.
typedef GetLangMapFunction = Map<String, dynamic> Function(Locale locale);

/// The MyLocalization class.
class MyLocalization {
  /// The default [notFoundString].
  static const defaultNotFoundString = '(?)';

  /// The current locale.
  final Locale locale;

  /// The get path function.
  final GetLangMapFunction getLangMapFunction;

  /// The string to return if the key is not found.
  final String notFoundString;

  /// The localized strings.
  final Map<String, String> _strings = HashMap();

  /// Creates a new ez localization instance.
  MyLocalization({
    required this.locale,
    required this.getLangMapFunction,
    required this.notFoundString,
  });

  /// Returns the MyLocalization instance attached to the specified build config.
  static MyLocalization? of(BuildContext context) =>
      Localizations.of<MyLocalization>(context, MyLocalization);

  /// Loads the localized strings.
  Future<bool> load() async {
    try {
      Map<String, dynamic> strings = getLangMapFunction(locale);
      strings.forEach((String key, dynamic data) => _addValues(key, data));
      return true;
    } catch (exception, stacktrace) {
      if (kDebugMode) {
        print(exception);
        print(stacktrace);
      }
    }
    return false;
  }

  /// Returns the string associated to the specified key.
  String get(String key, [dynamic args]) {
    String? value = _strings[key];
    if (value == null) {
      return notFoundString;
    }

    if (args != null) {
      value = _formatReturnValue(value, args);
    }

    return value;
  }

  /// Adds the values to the current map.
  void _addValues(String key, dynamic data) {
    if (data is Map) {
      data.forEach((subKey, subData) => _addValues('$key.$subKey', subData));
      return;
    }

    if (data != null) {
      _strings[key] = data.toString();
    }
  }

  /// Formats the return value according to the specified arguments.
  String _formatReturnValue(String value, dynamic arguments) {
    if (arguments is List) {
      for (int i = 0; i < arguments.length; i++) {
        value = value.replaceAll('{{$i}}', arguments[i].toString());
      }
    } else if (arguments is Map) {
      arguments.forEach(
        (formatKey, formatValue) => value = value.replaceAll(
          '{{$formatKey}}',
          formatValue.toString(),
        ),
      );
    }
    return value;
  }
}
