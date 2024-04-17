import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyToken = 'token';
const _keyRole = 'role';

class SessionService {
  SessionService(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  Future<String?> get token async {
    return _flutterSecureStorage.read(key: _keyToken);
  }

  Future<void> saveToken(String token) {
    return _flutterSecureStorage.write(key: _keyToken, value: token);
  }

  Future<void> signOut() async {
    return _flutterSecureStorage.delete(key: _keyToken);
  }

  Future<String?> get role async {
    return _flutterSecureStorage.read(key: _keyRole);
  }

  Future<void> saveRole(String role) {
    return _flutterSecureStorage.write(key: _keyRole, value: role);
  }
}
