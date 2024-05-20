import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/enums/usuario_estado.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/snackBar/snackbar_util.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import '../../user/views/usuario_detail_view.dart';
import 'state/sign_state.dart';

class SignController extends StateNotifier<SignState> {
  SignController(
    super.state, {
    required this.usuarioRepo,
    required this.context,
  });

  final UsuarioRepo usuarioRepo;
  final BuildContext context;

  set sign(SignState state) {
    this.state = state;
  }

  void onEmailChanged(String text) {
    final email = text.trim().toLowerCase();
    onlyUpdate(state.copyWith(email: email));
  }

  void onPasswordChanged(String text) {
    final password = text.trim();
    onlyUpdate(state.copyWith(password: password));
  }

  void onConfirmPasswordChanged(String text) {
    final password = text.trim();
    onlyUpdate(state.copyWith(confirmPassword: password));
  }

  void onVisibilityPasswordChanged(bool visible) {
    onlyUpdate(state.copyWith(obscurePassword: visible));
  }

  void onVisibilityConfirmPasswordChanged(bool visible) {
    onlyUpdate(state.copyWith(obscureConfirmPassword: visible));
  }

  void onChangeValueTipo(String text) {
    onlyUpdate(state.copyWith(rol: text));
  }

  Future<void> access({context, language}) async {
    final isOk = validarIsNotEmpty();

    if (isOk) {
      late Result<dynamic, dynamic> result;
      result = await usuarioRepo.signIn(state.email, state.password);

      result.when(
        (success) async {
          final usuario = await usuarioRepo.getUsuario();

          usuario.when((success) {
            if (success.rol == UsuarioTipo.admin.value) {
              navigateTo(Routes.admin, context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsuarioDetailView(
                    usuarioModel: success,
                  ),
                ),
              );
            }
          }, (error) => showError(error, language));
        },
        (error) {
          showError(error, language);
        },
      );
    } else {
      showError(FirebaseCode.checkEmailPassword, language);
    }
  }

  bool validarIsNotEmpty() {
    return state.email.isNotEmpty && state.password.isNotEmpty;
  }

  List<DropdownMenuItem<String>> get typeList {
    final language = AppLocalizations.of(context)!;

    return UsuarioTipo.values
        .where((element) => element != UsuarioTipo.admin)
        .map<DropdownMenuItem<String>>(
      (UsuarioTipo type) {
        final label = getEnumTypeString(type, language);

        return DropdownMenuItem<String>(
          value: type.value,
          alignment: Alignment.centerLeft,
          child: Text(label),
        );
      },
    ).toList();
  }

  String getEnumTypeString(UsuarioTipo enumValue, AppLocalizations language) {
    switch (enumValue) {
      case UsuarioTipo.cuidador:
        return language.cuidador;
      case UsuarioTipo.paciente:
        return language.paciente;
      case UsuarioTipo.gestorCasos:
        return language.gestor_casos;
      // case UsuarioTipo.gestor:
      //   return language.gestor;
      case UsuarioTipo.admin:
        return language.admin;
    }
  }

  void showError(error, language) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: error,
    );

    response.showError();
  }

  void showWarning(message) {
    final snackBarUtil = SnackBarUtils(
      context: context,
      message: message,
    );

    snackBarUtil.showWarning();
  }

  String getEstadoUsuarioLanguage(language, UsuarioEstado usuarioEstado) {
    switch (usuarioEstado) {
      case UsuarioEstado.activo:
        return language.activo;
      case UsuarioEstado.inactivo:
        return language.inactivo;
      case UsuarioEstado.validacion:
        return language.validacion;
    }
  }
}
