import 'package:flutter/material.dart';

class AppConstants {
  static const double maxWidth = 400;
  static const String formatDate = 'dd/MM/yyyy';
  static const String googleCloudAccountsV1 =
      'https://identitytoolkit.googleapis.com/v1';

  var headerStyle = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const String uriSendPushMessage =
      'https://fcm.googleapis.com/v1/projects/redela-81338/messages:send';
}
