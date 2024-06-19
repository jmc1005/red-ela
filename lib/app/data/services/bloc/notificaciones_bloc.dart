import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/app_constants.dart';
import '../local/notificacion_service.dart';
import '../local/preferencias_usuario.dart';
import '../remote/firebase_access_token.dart';

part 'notificaciones_event.dart';
part 'notificaciones_state.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final mensaje = message.data;
  final title = mensaje['title'];
  final body = mensaje['body'];
  final random = Random();
  final id = random.nextInt(100000);

  NotificacionService.showLocalNotification(id: id, title: title, body: body);
}

class NotificacionesBloc
    extends Bloc<NotificacionesEvent, NotificacionesState> {
  final messaging = FirebaseMessaging.instance;

  NotificacionesBloc() : super(NotificacionesInitial()) {
    _onForegroundMessage();
  }

  Future<void> requestPermission() async {
    await messaging.requestPermission();

    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    }

    await NotificacionService.requestPermissionLocalNotifications();
    _getFCMToken();
  }

  Future<void> _getFCMToken() async {
    try {
      final settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }

      String? token;

      final vapidKey = dotenv.get('VAPID_KEY');
      if (kIsWeb) {
        token = await messaging.getToken(vapidKey: vapidKey);
      } else {
        token = await messaging.getToken();
      }

      if (token != null) {
        final prefs = PreferenciasService();
        prefs.token = token;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleRemoteMessage(RemoteMessage message) {
    final remoteMessage = message.toMap();
    final mensaje = message.notification;
    debugPrint('remoteMessage: $remoteMessage');
    debugPrint('data: $mensaje');

    if (mensaje != null) {
      final notificacion = mensaje!.toMap();
      final title = notificacion['title'];
      final body = notificacion['body'];

      final random = Random();
      final id = random.nextInt(100000);

      NotificacionService.showLocalNotification(
          id: id, title: title, body: body);
    }
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> sendPushMessage(titulo, cuerpo, tokens) async {
    final firebaseAccessToken = FirebaseAccessToken();
    final accessToken = await firebaseAccessToken.getToken();

    if (tokens != null && tokens.isNotEmpty) {
      for (final token in tokens) {
        final body = {
          'message': {
            'token': token,
            'notification': {'body': cuerpo, 'title': titulo}
          }
        };

        try {
          await http.post(
            Uri.parse(AppConstants.uriSendPushMessage),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken'
            },
            body: jsonEncode(body),
          );
          debugPrint('FCM request for device sent!');
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }
}
