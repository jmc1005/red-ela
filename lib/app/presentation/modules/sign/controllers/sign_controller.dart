import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/firebase/firebase_code_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/routes.dart';
import 'state/sign_state.dart';

class SignController extends StateNotifier<SignState> {
  SignController(
    super.state, {
    required this.usuarioRepo,
  });

  final UsuarioRepo usuarioRepo;

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

  Future<void> access({isSignIn = true, context, language}) async {
    final isOk = validarIsNotEmpty(isSignIn: isSignIn);

    if (isOk) {
      late Result<dynamic, dynamic> result;

      if (isSignIn) {
        result = await usuarioRepo.signIn(state.email, state.password);
      } else {
        result = await usuarioRepo.signUp(state.email, state.password);
      }

      result.when(
        (success) {
          navigateTo(Routes.admin, context);
        },
        (error) {
          final response = FirebaseResponse(
            context: context,
            language: language,
            code: error,
          );

          response.showError();
        },
      );
    } else {
      final response = FirebaseResponse(
        context: context,
        language: language,
        code: FirebaseCode.checkEmailPassword,
      );

      response.showError();
    }
  }

  bool validarIsNotEmpty({isSignIn = false}) {
    if (isSignIn) {
      return state.email.isNotEmpty && state.password.isNotEmpty;
    }

    return state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty;
  }
}
