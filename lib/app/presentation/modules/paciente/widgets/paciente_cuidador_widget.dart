import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../invitacion/dialogs/invitar_usuario_dialog.dart';
import '../../user/controllers/usuario_controller.dart';

class PacienteCuidadorWidget extends StatefulWidget with ValidatorMixin {
  PacienteCuidadorWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacienteCuidadorWidget> createState() => _PacienteCuidadorWidgetState();
}

class _PacienteCuidadorWidgetState extends State<PacienteCuidadorWidget> {
  late final Future<Result<PacienteModel, dynamic>> futurePaciente;
  late final UsuarioModel? usuarioCuidador;
  late final CuidadorModel? cuidadorModel;
  final nombreCompletoController = TextEditingController();
  final telefonoController = TextEditingController();
  final relacionController = TextEditingController();

  final dateInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<Result<UsuarioModel, dynamic>> _getCuidadorPaciente(
    UsuarioController usuarioController,
  ) async {
    var paciente = usuarioController.state!.paciente;

    if (paciente == null) {
      final response =
          await usuarioController.pacienteController.pacienteRepo.getPaciente();
      response.when(
        (success) {
          paciente = success;
          usuarioController.paciente = success;
        },
        (error) => debugPrint(error),
      );
    }

    final usuarioRepo = usuarioController.usuarioRepo;

    if (paciente!.cuidador != null) {
      final cuidadorUid = paciente!.cuidador!;

      return usuarioRepo.getUsuarioByUid(uid: cuidadorUid);
    }

    return Future.value(const Error(null));
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          FutureBuilder(
            future: _getCuidadorPaciente(controller),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final response = snapshot.data!;

                response.when(
                  (success) async {
                    usuarioCuidador = success;

                    nombreCompletoController.text = success.nombreCompleto;
                    telefonoController.text = success.telefono ?? '';

                    final responseCuidador = await controller
                        .cuidadorController.cuidadorRepo
                        .getCuidadorByUid(success.uid);

                    responseCuidador.when(
                      (success) {
                        cuidadorModel = success;
                        relacionController.text = success.relacion;
                      },
                      (error) => debugPrint(error),
                    );
                  },
                  (error) => debugPrint(error),
                );

                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormWidget(
                          label: language.nombre_completo,
                          controller: nombreCompletoController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormWidget(
                          label: language.telefono,
                          keyboardType: TextInputType.phone,
                          controller: telefonoController,
                          prefixText: '+34 ',
                          readOnly: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: TextFormWidget(
                        label: language.relacion,
                        controller: relacionController,
                        keyboardType: TextInputType.text,
                        readOnly: true,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SubmitButtonWidget(
                      label: language.enviar_invitacion,
                      onPressed: () {
                        showInvitarUsuarioDialog(
                          context,
                          rol: UsuarioTipo.paciente.value,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
