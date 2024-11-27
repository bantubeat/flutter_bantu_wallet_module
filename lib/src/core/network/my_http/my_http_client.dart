import 'package:flutter/foundation.dart' show protected;

import 'my_http_response.dart';

abstract class MyHttpClient {
  final bool cacheEnabled;
  final String baseUrl;
  final Future<String?> Function()? getAccessToken;
  final Future<String?> Function()? refreshAccessToken;

  const MyHttpClient({
    required this.baseUrl,
    this.cacheEnabled = false,
    this.getAccessToken,
    this.refreshAccessToken,
  });

  @protected
  T parseData<T>(
    dynamic data, {
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    if (parseJson != null && data is Map) {
      return parseJson(data as Map<String, dynamic>);
    }

    if (parseList != null && data is List) {
      return parseList(data);
    }

    if (parseRaw != null) {
      return parseRaw(data);
    }

    return data as T;
  }

  Future<MyHttpResponse<T>> fetch<T>({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
    dynamic body,
  });

  Future<MyHttpResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    return fetch(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      parseRaw: parseRaw,
      parseJson: parseJson,
      parseList: parseList,
    );
  }

  Future<MyHttpResponse<T>> post<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    return fetch(
      method: 'POST',
      endpoint: endpoint,
      headers: headers,
      parseRaw: parseRaw,
      parseJson: parseJson,
      parseList: parseList,
      body: body,
    );
  }

  Future<MyHttpResponse<T>> patch<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    return fetch(
      method: 'PATCH',
      endpoint: endpoint,
      headers: headers,
      parseRaw: parseRaw,
      parseJson: parseJson,
      parseList: parseList,
      body: body,
    );
  }

  Future<MyHttpResponse<T>> put<T>(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    return fetch(
      method: 'PUT',
      endpoint: endpoint,
      headers: headers,
      parseRaw: parseRaw,
      parseJson: parseJson,
      parseList: parseList,
      body: body,
    );
  }

  Future<MyHttpResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
  }) {
    return fetch(
      method: 'DELETE',
      endpoint: endpoint,
      headers: headers,
      parseRaw: parseRaw,
      parseJson: parseJson,
      parseList: parseList,
    );
  }

  void close();
}
