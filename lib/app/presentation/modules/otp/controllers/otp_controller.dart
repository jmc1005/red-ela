import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../data/services/local/session_service.dart';
import '../../../../domain/models/invitacion/invitacion_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/cuidador_repo.dart';
import '../../../../domain/repository/gestor_casos_repo.dart';
import '../../../../domain/repository/invitacion_repo.dart';
import '../../../../domain/repository/paciente_repo.dart';
import '../../../../domain/repository/usuario_repo.dart';
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
  final SessionService sessionService;

  OTPController(
    super.state, {
    required this.usuarioRepo,
    required this.invitacionRepo,
    required this.pacienteRepo,
    required this.cuidadorRepo,
    required this.gestorCasosRepo,
    required this.sessionService,
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

    sessionService.saveSolicitado(solicitado);

    result.when(
      (success) {
        updateInvitacion(phoneNumber);

        final usuarioModel = UsuarioModel(
          uid: '',
          nombreCompleto: '',
          rol: rol,
          telefono: phoneNumber,
          email: '',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsuarioDetailView(
              usuarioModel: usuarioModel,
              allowUpdate: true,
            ),
          ),
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
}
