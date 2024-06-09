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
  late final UsuarioModel? usuarioGestorCaso;
  late final GestorCasosModel? gestorCasosModel;

  final nombreController = TextEditingController();
  final apellido1Controller = TextEditingController();
  final apellido2Controller = TextEditingController();
  final telefonoController = TextEditingController();
  final hospitalController = TextEditingController();

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
    var paciente = controller.state!.paciente;

    if (paciente == null) {
      final response =
          await controller.pacienteController.pacienteRepo.getPaciente();
      response.when(
        (success) {
          paciente = success;
          controller.paciente = success;
        },
        (error) => debugPrint(error),
      );
    }

    if (paciente!.gestorCasos != null) {
      final gestorCasos = paciente!.gestorCasos!;
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
                    usuarioGestorCaso = success;

                    nombreController.text = success.nombre ?? '';
                    apellido1Controller.text = success.apellido1 ?? '';
                    apellido2Controller.text = success.apellido2 ?? '';
                    telefonoController.text = success.telefono ?? '';

                    final responseGestorCasos = await controller
                        .gestorCasosController.gestorCasosRepo
                        .getGestorCasosByUid(success.uid);

                    responseGestorCasos.when(
                      (success) {
                        gestorCasosModel = success;
                        hospitalController.text = success.hospital ?? '';
                      },
                      (error) => debugPrint(error),
                    );
                  },
                  (error) => debugPrint(error),
                );

                return Column(
                  children: [
                    TextFormWidget(
                      label: language.nombre,
                      controller: nombreController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido,
                      controller: apellido1Controller,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.apellido2,
                      controller: apellido2Controller,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.hospital,
                      controller: hospitalController,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: language.telefono,
                      controller: telefonoController,
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
