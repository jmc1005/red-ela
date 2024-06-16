import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../local/preferencias_usuario.dart';
import '../local/notificacion_service.dart';

part 'notificaciones_event.dart';
part 'notificaciones_state.dart';

class NotificacionesBloc
    extends Bloc<NotificacionesEvent, NotificacionesState> {
  final messaging = FirebaseMessaging.instance;

  NotificacionesBloc() : super(NotificacionesInitial()) {
    _onForegroundMessage();
  }

  void requestPermission() async {
    final settings = await messaging.requestPermission();

    await NotificacionService.requestPermissionLocalNotifications();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    _getFCMToken();
  }

  void _getFCMToken() async {
    try {
      final token = await messaging.getToken();

      if (token != null) {
        final prefs = PreferenciasService();
        prefs.token = token;
      }

      // FirebaseFirestore.instance.doc('').set({'token': FieldValue.arrayUnion([token])},SetOptions(merge: true),);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleRemoteMessage(RemoteMessage message) {
    final mensaje = message.data;
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
