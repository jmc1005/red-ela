import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../snackBar/snackbar_util.dart';
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
      case FirebaseCode.otpError:
        return language.otp_error;
      case FirebaseCode.userRegistered:
        return language.registrado;
      case FirebaseCode.invalidVerificationCode:
        return language.codigoVerificacionInvalido;
      case FirebaseCode.reviewFormData:
        return language.reviseDatosFormulario;
    }

    return language.unknown;
  }

  void showSuccess() {
    final snackbarUtil = SnackBarUtils(context: context, message: codeString);
    snackbarUtil.showSuccess();
  }

  void showError() {
    final snackbarUtil = SnackBarUtils(context: context, message: codeString);
    snackbarUtil.showError();
  }

  void showWarning() {
    final snackbarUtil = SnackBarUtils(context: context, message: codeString);
    snackbarUtil.showWarning();
  }
}
