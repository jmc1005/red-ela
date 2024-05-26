import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/invitacion/invitacion_model.dart';
import '../../../../domain/repository/cuidador_repo.dart';
import '../../../../domain/repository/gestor_casos_repo.dart';
import '../../../../domain/repository/invitacion_repo.dart';
import '../../../../domain/repository/paciente_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../user/views/usuario_detail_view.dart';
import 'state/otp_state.dart';

class OTPController extends StateNotifier<OTPState> {
  final UsuarioRepo usuarioRepo;
  final InvitacionRepo invitacionRepo;
  final PacienteRepo pacienteRepo;
  final CuidadorRepo cuidadorRepo;
  final GestorCasosRepo gestorCasosRepo;

  OTPController(
    super.state, {
    required this.usuarioRepo,
    required this.invitacionRepo,
    required this.pacienteRepo,
    required this.cuidadorRepo,
    required this.gestorCasosRepo,
  });

  Future<Result<InvitacionModel, dynamic>> obtenerInvitacion(
      String phoneNumber) async {
    return invitacionRepo.getInvitacion(phoneNumber);
  }

  Future<void> enviarOTP({
    required String phoneNumber,
    required String rol,
    required String solicitado,
    required BuildContext context,
  }) async {
    await usuarioRepo.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      rol: rol,
      solicitado: solicitado,
      context: context,
    );
  }

  Future<void> updateInvitacion(String phoneNumber) async {
    await invitacionRepo.updateInvitacion(phoneNumber, 'aceptado');
  }

  Future<void> confirmar(
      {required String phoneNumber,
      required String rol,
      required String solicitado,
      required String codigo,
      required String verificationId,
      required AppLocalizations language,
      required BuildContext context}) async {
    final result = await usuarioRepo.signUpPhoneNumber(
      rol: rol,
      smsCode: codigo,
      verificationId: verificationId,
    );

    result.when(
      (success) async {
        final usuario = await usuarioRepo.getUsuario();

        usuario.when(
          (success) {
            updateInvitacion(phoneNumber);
            updateUsuarioBySolicitado(solicitado, rol);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsuarioDetailView(
                  usuarioModel: success,
                ),
              ),
            );
          },
          (error) => showError(error, language, context),
        );
      },
      (error) => showError(error, language, context),
    );
  }

  void changePhoneNumber(String value) {
    onlyUpdate(state.copyWith(phoneNumber: value));
  }

  void changeVerificationId(verificationId) {
    onlyUpdate(state.copyWith(verificationId: verificationId));
  }

  void changeVisible() {
    final visible = state.visible;
    final otp = state.copyWith(visible: !visible);
    onlyUpdate(otp);
  }

  void showError(error, language, context) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: error,
    );

    response.showError();
  }

  void showWarning(error, language, context) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: error,
    );

    response.showWarning();
  }

  Future<void> updateUsuarioBySolicitado(String solicitado, String rol) async {
    if (rol == UsuarioTipo.paciente.value) {
      await pacienteRepo.updatePacienteRelacion(solicitado: solicitado);
    }
    if (rol == UsuarioTipo.cuidador.value) {
      await cuidadorRepo.updateCuidadorRelacion(solicitado: solicitado);
    }
  }
}
