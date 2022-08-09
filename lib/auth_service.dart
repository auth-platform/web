import 'dart:async';

import 'package:auth_platform/api/api_response.dart';
import 'package:auth_platform/api/api_service.dart';
import 'package:auth_platform/models/auth_data.dart';
import 'package:hive/hive.dart';

class AuthService {
  static final shared = AuthService(APIService.shared);

  AuthService(this._service);

  initialize() async {
    _box = await Hive.openBox('auth');
    _box.watch(key: 'data').listen((_) => _handleDataUpdated());
    _handleDataUpdated();
  }

  final APIService _service;
  late final Box _box;

  AuthData? get data {
    final json = _box.get('data');
    return json != null ? AuthData.fromMap(json) : null;
  }

  bool get isAuthenticated => data != null;

  final _streamController = StreamController<bool>.broadcast();
  late final Stream<bool> isAuthenticatedStream = _streamController.stream;

  Future<void> login(email, pwd) async {
    try {
      APIResponse<AuthData> res = await _service.request('auth', method: 'POST', data: {'email': email, 'pwd': pwd});
      await _box.put('data', res.data.toMap());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future changePassword(pwd, newPwd) =>
      _service.request('user/pwd', method: 'PUT', data: {'pwd': pwd, 'newPwd': newPwd});

  Future logout() => _box.delete('data');

  _handleDataUpdated() {
    _service.updateBearerToken(data?.token);
    _streamController.add(data != null);
  }
}
