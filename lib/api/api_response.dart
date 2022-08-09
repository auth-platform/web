class APIResponse<T> {
  late final bool success;
  late final int? code;
  late final T data;

  APIResponse(this.success, this.code, this.data);

  APIResponse<X> map<X>(X Function(T? data) parse) => APIResponse(success, code, parse(data));

  APIResponse.fromMap(Map map, int? statusCode, T Function(Map? data) parse) {
    success = map['success'];
    code = statusCode;
    data = parse(map['data']);
  }
}
