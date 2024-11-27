import 'dart:convert';

class MyHttpException implements Exception {
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? body;

  const MyHttpException({
    this.statusCode = 0,
    this.message,
    this.body,
  }) : assert(statusCode >= 0);

  @override
  String toString() {
    return jsonEncode({
      'type': runtimeType.toString(),
      'statusCode': statusCode,
      'message': message,
      'body': body,
    });
  }
}

class MyHttpNoInternetException extends MyHttpException {
  const MyHttpNoInternetException({
    super.message,
    super.body,
  }) : super(statusCode: 0);
}

class MyHttpClientSideException extends MyHttpException {
  const MyHttpClientSideException({
    required super.statusCode,
    super.message,
    super.body,
  }) : assert(statusCode >= 400 && statusCode < 500);
}

class MyHttpBadRequestException extends MyHttpClientSideException {
  const MyHttpBadRequestException({
    super.message,
    super.body,
  }) : super(statusCode: 400);
}

class MyHttpUnprocessableContentException extends MyHttpClientSideException {
  final Map<String, List<String>>? errors;

  MyHttpUnprocessableContentException({
    String? message,
    super.body,
  })  : errors = (body?['errors'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, (v as List).map((e) => e.toString()).toList()),
        ),
        super(message: body?['message'] ?? message, statusCode: 422);
}

class MyHttpForbiddenException extends MyHttpClientSideException {
  const MyHttpForbiddenException({
    super.message,
    super.body,
  }) : super(statusCode: 403);
}

class MyHttpUnauthorizedException extends MyHttpClientSideException {
  const MyHttpUnauthorizedException({
    super.message,
    super.body,
  }) : super(statusCode: 401);
}

class MyHttpNotFoundException extends MyHttpClientSideException {
  const MyHttpNotFoundException({
    super.message,
    super.body,
  }) : super(statusCode: 404);
}

class MyHttpServerSideException extends MyHttpException {
  const MyHttpServerSideException({
    required super.statusCode,
    super.message,
    super.body,
  }) : assert(statusCode >= 500);
}

class MyHttpInternalServerErrorException extends MyHttpServerSideException {
  const MyHttpInternalServerErrorException({
    super.message,
    super.body,
  }) : super(statusCode: 500);
}

T throwMyHttpException<T>({
  int? statusCode,
  dynamic errorBody,
}) {
  String? message;
  Map<String, dynamic>? body;
  if (errorBody is Map) {
    body = errorBody as Map<String, dynamic>;
    message = body['message'];
  } else if (errorBody is String) {
    try {
      body = json.decode(errorBody) as Map<String, dynamic>?;
      message = body != null ? body['message'] : null;
    } catch (_) {
      message = errorBody;
    }
  }

  switch (statusCode) {
    case null:
    case 0:
      throw MyHttpNoInternetException(body: body, message: message);

    case 400:
      throw MyHttpBadRequestException(body: body, message: message);

    case 422:
      throw MyHttpUnprocessableContentException(body: body, message: message);

    case 401:
      throw MyHttpUnauthorizedException(body: body, message: message);

    case 403:
      throw MyHttpForbiddenException(body: body, message: message);

    case 404:
      throw MyHttpNotFoundException(body: body, message: message);

    case 500:
      throw MyHttpInternalServerErrorException(body: body, message: message);

    default:
      {
        if (statusCode >= 400 && statusCode < 500) {
          throw MyHttpClientSideException(
            statusCode: statusCode,
            body: body,
            message: message,
          );
        }

        if (statusCode >= 500) {
          throw MyHttpServerSideException(
            statusCode: statusCode,
            body: body,
            message: message,
          );
        }

        throw MyHttpException(
          statusCode: statusCode,
          body: body,
          message: message,
        );
      }
  }
}
