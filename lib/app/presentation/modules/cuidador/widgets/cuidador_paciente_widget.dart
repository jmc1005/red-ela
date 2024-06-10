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

class CuidadorPacienteWidget extends StatefulWidget with ValidatorMixin {
  CuidadorPacienteWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<CuidadorPacienteWidget> createState() => _CuidadorPacienteWidgetState();
}

class _CuidadorPacienteWidgetState extends State<CuidadorPacienteWidget> {
  late final Future<Result<CuidadorModel, dynamic>> futurePaciente;
  late final UsuarioModel? usuarioCuidador;
  late final PacienteModel? pacienteModel;

  final nombreCompletoController = TextEditingController();
  final telefonoController = TextEditingController();

  final dateInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<Result<UsuarioModel, dynamic>> _getPacienteCuidador(
    UsuarioController usuarioController,
  ) async {
    var cuidador = usuarioController.state!.cuidador;

    if (cuidador == null) {
      final response =
          await usuarioController.cuidadorController.cuidadorRepo.getCuidador();
      response.when(
        (success) {
          cuidador = success;
          usuarioController.cuidador = success;
        },
        (error) => debugPrint(error),
      );
    }

    final usuarioRepo = usuarioController.usuarioRepo;

    if (cuidador!.pacientes != null && cuidador!.pacientes!.isNotEmpty) {
      final pacienteUid = cuidador!.pacientes![0];

      return usuarioRepo.getUsuarioByUid(uid: pacienteUid);
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
            future: _getPacienteCuidador(controller),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final response = snapshot.data!;

                response.when(
                  (success) async {
                    usuarioCuidador = success;

                    nombreCompletoController.text = success.nombreCompleto;
                    telefonoController.text = success.telefono ?? '';
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
                      child: Row(
                        children: [
                          Flexible(
                            child: TextFormWidget(
                              label: language.telefono,
                              keyboardType: TextInputType.phone,
                              controller: telefonoController,
                              prefixText: '+34 ',
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
