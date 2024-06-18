import 'dart:io' show Platform;
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../local/notificacion_service.dart';
import '../local/preferencias_usuario.dart';

part 'notificaciones_event.dart';
part 'notificaciones_state.dart';

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
    final mensaje = message.data;
    debugPrint('mensaje: $mensaje');

    final title = mensaje['title'];
    final body = mensaje['body'];

    final random = Random();
    final id = random.nextInt(100000);

    NotificacionService.showLocalNotification(id: id, title: title, body: body);
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }
}
