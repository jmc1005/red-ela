import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../invitacion/views/invitar_usuario_dialog.dart';
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

  final dateInput = TextEditingController();

  var headerStyle = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  void _showError(error, language) {
    final response = FirebaseResponse(
      context: context,
      language: language,
      code: error,
    );

    response.showError();
  }

  void _setPacienteVacio() {
    const paciente = PacienteModel(usuarioUid: '');
    widget.usuarioController.paciente = paciente;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Result<UsuarioModel, dynamic>> _getCuidadorPaciente(
    UsuarioController controller,
  ) async {
    final paciente = controller.state!.paciente;
    final cuidadorRepo = null; // controller.pacienteController.cuidadorRepo;

    if (paciente!.cuidador != null) {
      final cuidadorUid = paciente.cuidador!.usuarioUid;
      return cuidadorRepo.getUsuarioCuidadorByUid(cuidadorUid);
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
                return Column(
                  children: [
                    TextFormWidget(
                      label: language.nombre,
                      initialValue: usuarioCuidador?.nombre != null
                          ? usuarioCuidador!.nombre
                          : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido,
                      initialValue: usuarioCuidador?.apellido1 != null
                          ? usuarioCuidador!.apellido1
                          : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido2,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.relacion,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
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
