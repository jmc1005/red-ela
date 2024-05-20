import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _currentUid = 'current_uid';

class SessionService {
  SessionService(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  Future<String?> get currentUid async {
    return _flutterSecureStorage.read(key: _currentUid);
  }

  Future<void> saveCurrentUid(String currentUid) {
    return _flutterSecureStorage.write(key: _currentUid, value: currentUid);
  }
}
