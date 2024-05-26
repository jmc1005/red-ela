import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyCurrentUid = 'current_uid';
const _keyRol = 'rol';

class SessionService {
  SessionService(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  Future<String?> get currentUid async {
    return _flutterSecureStorage.read(key: _keyCurrentUid);
  }

  Future<void> saveCurrentUid(String currentUid) {
    return _flutterSecureStorage.write(key: _keyCurrentUid, value: currentUid);
  }

  Future<String?> get rol async {
    return _flutterSecureStorage.read(key: _keyRol);
  }

  Future<void> saveRol(String rol) {
    return _flutterSecureStorage.write(key: _keyRol, value: rol);
  }
}
