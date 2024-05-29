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
  ];

  EncryptData._() {
    getSecureKey();
  }

  static Future<void> getSecureKey() async {
    await dotenv.load();
    _encryptKey = dotenv.get('ENCRYPT_KEY');
    _encryptIV = dotenv.get('ENCRYPT_IV');
  }

  static Future<String> encryptData(String plainText) async {
    await getSecureKey();

    final key = Key.fromUtf8(_encryptKey);
    final iv = IV.fromUtf8(_encryptIV);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final encoded = base64.encode(encrypted.bytes);

    return encoded;
  }

  static Future<String?> decryptData(String? encryptedText) async {
    await getSecureKey();

    final key = Key.fromUtf8(_encryptKey);
    final iv = IV.fromUtf8(_encryptIV);
    final encrypter = Encrypter(AES(key));

    if (encryptedText == null) {
      return '';
    }

    final encryptedBytes = base64.decode(encryptedText);
    final encrypted = Encrypted(encryptedBytes);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  static Future<Json> decryptDataJson(Json json) async {
    await getSecureKey();
    final Json result = json;

    json.forEach((key, value) async {
      if (!notDecryptList.contains(key) && value.toString().isNotEmpty) {
        final decrypt = await decryptData(value);
        result[key] = decrypt;
      }
    });

    material.debugPrint(jsonEncode(result));

    return Future.value(result);
  }
}
