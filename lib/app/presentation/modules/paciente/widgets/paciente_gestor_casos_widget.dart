import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/validators/validator_mixin.dart';

import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class PacienteGestorCasosWidget extends StatefulWidget with ValidatorMixin {
  PacienteGestorCasosWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacienteGestorCasosWidget> createState() =>
      _PacienteGestorCasosWidgetState();
}

class _PacienteGestorCasosWidgetState extends State<PacienteGestorCasosWidget> {
  late final Future<Result<PacienteModel, dynamic>> futurePaciente;
  late final UsuarioModel? usuarioCuidador;
  late final GestorCasosModel? gestorCasosModel;

  final dateInput = TextEditingController();

  var headerStyle = const TextStyle(
    color: Color(0xffffffff),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<Result<UsuarioModel, dynamic>> _getGestorCasosPaciente(
    UsuarioController controller,
  ) async {
    final paciente = controller.state!.paciente;

    if (paciente!.gestorCasos != null) {
      final gestorCasos = paciente.gestorCasos!;
      return controller.usuarioRepo.getUsuarioByUid(uid: gestorCasos);
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
            future: _getGestorCasosPaciente(controller),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                final response = snapshot.data!;

                response.when(
                  (success) async {
                    usuarioCuidador = success;
                    final responseCuidador = await controller
                        .gestorCasosController.gestorCasosRepo
                        .getGestorCasosByUid(success.uid);

                    responseCuidador.when(
                      (success) => gestorCasosModel = success,
                      (error) => debugPrint(error),
                    );
                  },
                  (error) => debugPrint(error),
                );

                return Column(
                  children: [
                    TextFormWidget(
                      label: language.nombre,
                      initialValue: usuarioCuidador?.nombre ?? '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido,
                      initialValue: usuarioCuidador?.apellido1 ?? '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido2,
                      initialValue: usuarioCuidador?.apellido2 ?? '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.hospital,
                      initialValue: gestorCasosModel?.hospital ?? '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.telefono,
                      keyboardType: TextInputType.phone,
                      prefixText: '+34 ',
                      readOnly: true,
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    TextFormWidget(
                      label: language.nombre,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido,
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
                      label: language.hospital,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.telefono,
                      keyboardType: TextInputType.phone,
                      prefixText: '+34 ',
                      readOnly: true,
                    ),
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
