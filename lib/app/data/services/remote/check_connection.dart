import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class CheckConnection {
  Future<bool> hasInternet() async {
    try {
      if (kIsWeb) {
        final response = await get(Uri.parse('google.com'));
        return response.statusCode == 200;
      } else {
        final list = await InternetAddress.lookup('google.com');
        return list.isNotEmpty && list.first.rawAddress.isNotEmpty;
      }
    } catch (e) {
      developer.log("Couldn't check connection");
      return false;
    }
  }
}
