import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../domain/models/typedefs.dart';

class EncryptData {
  static String _encryptKey = '';
  static String _encryptIV = ''; // 128-bit IV

  static const List<String> notDecryptList = [
    'uid',
    'uuid',
    'email',
    'telefono',
    'pacientes',
    'cuidador',
    'gestor_caso',
    'usuario_uid',
    'uid_paciente',
    'uid_gestor_casos',
    'uid_cuidador',
    'token',
    'solicitado',
  ];

  EncryptData._() {
    getSecureKey();
  }

  static void getSecureKey() {
    _encryptKey = dotenv.get('ENCRYPT_KEY');
    _encryptIV = dotenv.get('ENCRYPT_IV');
  }

  static Future<String> encryptData(String plainText) async {
    getSecureKey();

    if (plainText.isNotEmpty) {
      final key = Key.fromUtf8(_encryptKey);
      final iv = IV.fromUtf8(_encryptIV);

      final encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      final encoded = base64.encode(encrypted.bytes);

      return encoded;
    }

    return '';
  }

  static Future<String?> decryptData(String? encryptedText) async {
    getSecureKey();

    final key = Key.fromUtf8(_encryptKey);
    final iv = IV.fromUtf8(_encryptIV);
    final encrypter = Encrypter(AES(key));

    if (encryptedText == '' || encryptedText == null) {
      return '';
    }

    final encryptedBytes = base64.decode(encryptedText);
    final encrypted = Encrypted(encryptedBytes);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static Future<Json> decryptDataJson(Json json) async {
    final Json result = json;
    try {
      getSecureKey();

      json.forEach((key, value) async {
        if (!notDecryptList.contains(key) && value.toString().isNotEmpty) {
          final decrypt = await decryptData(value);
          result[key] = decrypt;
        }
      });
    } catch (e) {
      material.debugPrint(e.toString());
    }

    return Future.value(result);
  }
}
