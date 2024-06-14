import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _keyCurrentUid = 'current_uid';
const _keyRol = 'rol';
const _keyVerificationId = 'verificationId';
const _keySmsCode = 'smsCode';
const _keySolicitado = 'solicitado';

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

  Future<String?> get verificationId async {
    return _flutterSecureStorage.read(key: _keyVerificationId);
  }

  Future<void> saveVerificationId(String verificationId) {
    return _flutterSecureStorage.write(
      key: _keyVerificationId,
      value: verificationId,
    );
  }

  Future<String?> get smsCode async {
    return _flutterSecureStorage.read(key: _keySmsCode);
  }

  Future<void> saveSmsCode(String smsCode) {
    return _flutterSecureStorage.write(key: _keySmsCode, value: smsCode);
  }

  Future<String?> get solicitado async {
    return _flutterSecureStorage.read(key: _keySolicitado);
  }

  Future<void> saveSolicitado(String? solicitado) {
    return _flutterSecureStorage.write(key: _keySolicitado, value: solicitado);
  }
}
