import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  static late SharedPreferences _prefs;

  static const _keyToken = 'token';
  static const _keyCurrentUid = 'current_uid';
  static const _keyRol = 'rol';
  static const _keyVerificationId = 'verificationId';
  static const _keySmsCode = 'smsCode';
  static const _keySolicitado = 'solicitado';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs.getString(_keyToken) ?? '';
  }

  set token(String value) {
    _prefs.setString(_keyToken, value);
  }

  String get currentUid {
    return _prefs.getString(_keyCurrentUid) ?? '';
  }

  set currentUid(String value) {
    _prefs.setString(_keyCurrentUid, value);
  }

  String get rol {
    return _prefs.getString(_keyRol) ?? '';
  }

  set rol(String value) {
    _prefs.setString(_keyRol, value);
  }

  String get verificationId {
    return _prefs.getString(_keyVerificationId) ?? '';
  }

  set verificationId(String value) {
    _prefs.setString(_keyVerificationId, value);
  }

  String get smsCode {
    return _prefs.getString(_keySmsCode) ?? '';
  }

  set smsCode(String value) {
    _prefs.setString(_keySmsCode, value);
  }

  String get solicitado {
    return _prefs.getString(_keySolicitado) ?? '';
  }

  set solicitado(String value) {
    _prefs.setString(_keySolicitado, value);
  }
}
