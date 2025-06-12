import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:flutter/foundation.dart';

import '../my_http_client.dart';
import '../my_http_exceptions.dart';
import '../my_http_response.dart';

class MyHttpClientDioImplemenation extends MyHttpClient {
  final Dio _dio;

  MyHttpClientDioImplemenation({
    required super.baseUrl,
    super.cacheEnabled = false,
    super.getAccessToken,
    super.refreshAccessToken,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: _removeTrailingSlash(baseUrl),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach the current access token to every request
          final token = getAccessToken != null ? await getAccessToken!() : null;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); // Continue the request
        },
        onError: (DioException err, handler) async {
          // Handle 401 Unauthorized and refresh the token
          if (err.response?.statusCode == 401) {
            try {
              final newToken = refreshAccessToken != null
                  ? await refreshAccessToken!()
                  : null;
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              // Retry the original request with the new token
              final cloneRequest = await _dio.request(
                err.requestOptions.path,
                options: Options(
                  method: err.requestOptions.method,
                  headers: err.requestOptions.headers,
                ),
                data: err.requestOptions.data,
                queryParameters: err.requestOptions.queryParameters,
              );
              return handler.resolve(cloneRequest);
            } catch (e) {
              // If refreshing token fails, reject the error
              return handler.reject(err);
            }
          }
          return handler.next(err); // Continue other errors
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        AwesomeDioInterceptor(
          // Disabling headers and timeout would minimize the logging output.
          // Optional, defaults to true
          logRequestTimeout: true,
          logRequestHeaders: true,
          logResponseHeaders: true,

          // Optional, defaults to the 'log' function in the 'dart:developer' package.
          logger: debugPrint,
        ),
      );
    }

    if (cacheEnabled) {
      _dio.interceptors.add(
        DioCacheInterceptor(
          options: CacheOptions(
            store: BackupCacheStore(
              primary: MemCacheStore(),
              secondary: HiveCacheStore(null),
            ),
            policy: CachePolicy.forceCache,
            maxStale: const Duration(days: 1),
          ),
        ),
      );
    }
  }

  static String _removeTrailingSlash(String url) {
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static String _ensureLeadingSlash(String path) {
    return path.startsWith('/') ? path : '/$path';
  }

  @override
  Future<MyHttpResponse<T>> fetch<T>({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    T Function(dynamic)? parseRaw,
    T Function(Map<String, dynamic>)? parseJson,
    T Function(List<dynamic>)? parseList,
    dynamic body,
  }) {
    final path = endpoint.startsWith(RegExp(r'https?:'))
        ? endpoint
        : _ensureLeadingSlash(endpoint);
    return _dio
        .request(
          path,
          data: body,
          options: Options(
            method: method,
            headers: headers ?? _dio.options.headers,
          ),
        )
        .then(
          (r) => MyHttpResponse<T>(
            statusCode: r.statusCode ?? 0,
            data: parseData<T>(
              r.data,
              parseRaw: parseRaw,
              parseJson: parseJson,
              parseList: parseList,
            ),
          ),
        )
        .catchError(
      (err) {
        debugPrint('[MyHttpClient - error] $err');
        final dioException = err is DioException ? err : null;
        return throwMyHttpException<MyHttpResponse<T>>(
          statusCode: dioException?.response?.statusCode,
          errorBody: dioException?.response?.data,
        );
      },
    );
  }

  @override
  void close() => _dio.close();
}
