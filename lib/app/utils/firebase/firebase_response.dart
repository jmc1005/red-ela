import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'firebase_code_enum.dart';

class FirebaseResponse {
  final AppLocalizations language;
  final BuildContext context;
  final String code;

  FirebaseResponse({
    required this.context,
    required this.language,
    required this.code,
  });

  String get codeString {
    switch (code) {
      case FirebaseCode.userNotFound:
        return language.usuarioNoEncontrado;
      case FirebaseCode.userSignInFailed:
        return language.registroFallido;
      case FirebaseCode.dataGetFailed:
        return language.obtenerDatosFallido;
      case FirebaseCode.dataUpdated:
        return language.actualizarDatos;
      case FirebaseCode.dataUpdateFailed:
        return language.actualizarDatosFallido;
      case FirebaseCode.dataAdded:
        return language.insertarDatos;
      case FirebaseCode.dataAddFailed:
        return language.insertarDatosFallido;
      case FirebaseCode.dataDeleted:
        return language.borrarDatos;
      case FirebaseCode.dataDeleteFailed:
        return language.borrarDatosFallido;
      case FirebaseCode.wrongPassword:
        return language.passwordIncorrecta;
      case FirebaseCode.weakPassword:
        return language.passwordDebil;
      case FirebaseCode.emailAlreadyInUse:
        return language.emailEnUso;
      case FirebaseCode.checkEmailPassword:
        return language.compruebaDatosAccesso;
    }

    return language.unknown;
  }

  void showSuccess() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: codeString),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.endToStart],
      snackBarPosition: SnackBarPosition.bottom,
    );
  }

  void showError() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: codeString),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.endToStart],
      snackBarPosition: SnackBarPosition.bottom,
    );
  }

  void showWarning() {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: codeString),
      dismissType: DismissType.onSwipe,
      dismissDirection: [DismissDirection.endToStart],
      snackBarPosition: SnackBarPosition.bottom,
    );
  }
}
