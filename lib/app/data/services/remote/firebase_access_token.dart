import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FirebaseAccessToken {
  static String firebaseMsgScope =
      'https://www.googleapis.com/auth/firebase/firebase.messaging';
  Future<String> getToken() async {
    try {
      final credentials = ServiceAccountCredentials.fromJson({
        'type': 'service_account',
        'project_id': 'redela-81338',
        'private_key_id': 'bf6fcb7e557137cb60d1a1474a784688c8a7fbef',
        'private_key':
            '-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCeOPyR33/92zs4\nXLJAqvlbtBMu4a0HDr8zfdRrhNkMMzs809VomRiY/HZXby8l20w/o+9SVfJTJUnx\n3gAmd0f1RBeFi71DkConKLCYcvZxxxZRAWgGoalejulv9JdcpnQyeZ7Ju27RuwHV\nDS09OvMQDLwrhYKyfP/PYuSs7/yQDZUPF5RoskhafE3DVWsWqIZQDp/tHG5YQuJr\n/8s6bW+6t/4dUAZfgVBbffTZdVjun8rFAvflE9KRw6Fz7xYgF2X3BW0N2TsLP73r\n5dNpjiQFtOj2qG2a5/K+AW9VwD7Gft/ZAz97nzpGqDzra5mVgyHrYgYugZXHXy6R\nnZDdlOmHAgMBAAECggEANPhGEj39VwrwsgdSg9TZg2pva6gQ6cZ1m3L6TP6ePXff\nUpdmoEx00C7hHZdy9N0Mk1e6NNniNRTMQyV77mTLmeBwcXydYcOfYRm9uWPvfprU\nrUznuySfE7GLlDgR/moZh5Zw4v+Vc7CERgPRy+hy3EIvMvDRFxlC+PaWMRFs//qM\noFNJDSfi3rNZoG7aGA+RTYZIdLUjg+Odz42E2s7p4oKvl5+hapsg2Zjm6K0BqROu\nKo7FAmpro+muH3y3AwNrhDSJhP220ElZChDcrWhwL1G5X+1GP5my7jyKmuKx75c1\nbXItgkjS2JwXrrdQ59OQiPgrANglOll4Z4NMZsgKXQKBgQDe9PAgRsg2RRECaOGu\n5VV6KCQFa51KbocLVd49vqv4s1rVmWqKbkB6jTOesBUarBZxLt73h/ZlzMdW6Hu/\n4k7Nbfro7iPeIh8wkhMawY+pkxjX5gEDHgh5nnaHKvWn1IqhfmkREMwJZasv4tu6\n4L96bX1e24D0gXSnE5kPRwhTXQKBgQC1rAKOJxKBaYBc4A/LEf6A2f8+i5UbvsJf\nM9JzekbPPTdjVGBP1zo5zxYxS8GnnUqdUmLBrPiTshLrszj31uEQKMG8Hi1eqSxk\nK4IrQt9n0pvHTfYYtvHeBDd3Mv8J/Mw3cFmckBmfcGNPnOJ1u+fHnnY5D+77PRlE\nmyllNHamMwKBgB1elJcb29nSRUhU+o2oZhceXIheQa0BXEaw/AKUMGEldyy19ePg\nXBwIp6kattz5mEc2jmZ7AYktbYDURSDktc630xqF7DGhuwwR4fRfVQZYeyhNgwqf\nFSy4JBLwJMYD6HMXjM2Tsdz3CJLZRmqamn6NF7u8HIOY3f34RexORhl9AoGAJ4Ye\noDKb8g+z34DXrsRhbEMBJuhTLlAYFYI+vOTTVu7oh/GpanVWs5D8MQlcPk0YGJX9\n6kjpY6iQOTsqn7DeEhfr3jNqh3eissBMd4D6/alyPrAVZFcY08ZzErnDhra67yzA\nMjGfgXKACKgHFLomuOUer1dqFLq8LpLbNKtvTMUCgYB566ngg8agPq7/gDF/OLNv\ntbbWcn6//nNdYTbsX6TNlm7qT5lz+ieECMN/SxgzDqCxkFI8Tu/mE/iLBYXAv1JW\nqnlDiyjD4LX5vRtosWLGAMjpjJTPVaAO3lhWB/Vf/T3/W/PFY38cVjNkV1VUvFaW\n6MB/IEHkJyt6JoE87MPyPA==\n-----END PRIVATE KEY-----\n',
        'client_email':
            'firebase-adminsdk-thm7m@redela-81338.iam.gserviceaccount.com',
        'client_id': '100289033171272194233',
        'auth_uri': 'https://accounts.google.com/o/oauth2/auth',
        'token_uri': 'https://oauth2.googleapis.com/token',
        'auth_provider_x509_cert_url':
            'https://www.googleapis.com/oauth2/v1/certs',
        'client_x509_cert_url':
            'https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-thm7m%40redela-81338.iam.gserviceaccount.com',
        'universe_domain': 'googleapis.com'
      });

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await obtainAccessCredentialsViaServiceAccount(
        credentials,
        scopes,
        http.Client(),
      );

      final accessToken = client;
      Timer.periodic(const Duration(minutes: 59), (timer) {
        accessToken.refreshToken;
      });

      return accessToken.accessToken.data;
    } catch (e) {
      debugPrint(e.toString());
    }

    return '';
  }
}
