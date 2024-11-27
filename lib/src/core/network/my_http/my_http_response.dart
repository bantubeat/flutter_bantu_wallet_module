class MyHttpResponse<T> {
  final int statusCode;
  final T data;

  const MyHttpResponse({
    required this.statusCode,
    required this.data,
  });
}
