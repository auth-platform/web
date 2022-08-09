import 'package:auth_platform/models/auth_data.dart';

class APIDataDecoder {
  static final shared = APIDataDecoder();

  T decode<T>(dynamic data) {
    switch (T) {
      case AuthData:
        return AuthData.fromMap(data) as T;
      default:
        return data;
    }
  }
}
