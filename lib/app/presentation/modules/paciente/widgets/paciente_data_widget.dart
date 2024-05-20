import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/submit_button_widget.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';

class PacienteDataWidget extends StatefulWidget with ValidatorMixin {
  PacienteDataWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacienteDataWidget> createState() => _PacienteDataWidgetState();
}

class _PacienteDataWidgetState extends State<PacienteDataWidget> {
  late final Future<Result<PacienteModel, dynamic>> futurePaciente;
  late final UsuarioModel? usuarioCuidador;

  final dateInput = TextEditingController();

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
    futurePaciente = _getFuturePaciente();
  }

  Future<Result<PacienteModel, dynamic>> _getFuturePaciente() async {
    return widget.usuarioController.pacienteController.pacienteRepo
        .getPaciente();
  }

  Future<void> _getCuidadorPaciente(
    UsuarioController controller,
    language,
  ) async {
    final paciente = controller.state!.paciente;
    final cuidadorRepo = controller.pacienteController.cuidadorRepo;

    if (paciente!.cuidador != null) {
      final cuidadorUid = paciente.cuidador!.usuarioUid;
      final futureCuidador =
          await cuidadorRepo.getUsuarioCuidadorByUid(cuidadorUid);

      futureCuidador.when(
        (success) {
          usuarioCuidador = success;
        },
        (error) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    PacienteModel? paciente = controller.state?.paciente;
    CuidadorModel? cuidador = controller.state?.cuidador;

    return FutureBuilder(
      future: _getFuturePaciente(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          final result = data.when(
            (success) => success,
            (error) => error,
          );

          if (result is PacienteModel) {
            controller.paciente = result;
            _getCuidadorPaciente(controller, language);
            paciente = controller.state!.paciente;
            cuidador = paciente?.cuidador;

            if (paciente!.fechaDiagnostico != null &&
                paciente!.fechaDiagnostico!.isNotEmpty) {
              dateInput.text = paciente!.fechaDiagnostico!;
            }
            if (usuarioCuidador != null) {
              debugPrint(usuarioCuidador!.toString());
            }
          } else {
            final response = FirebaseResponse(
              context: context,
              language: language,
              code: result,
            );

            response.showError();
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          _setPacienteVacio();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: TextFormWidget(
                      label: language.tratamiento,
                      initialValue: paciente?.tratamiento,
                      keyboardType: TextInputType.text,
                      onChanged: (text) => controller.onChangeTratamiento(text),
                      validator: (value) => widget.textValidator(
                        value,
                        language,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: TextFormWidget(
                      label: language.inicio,
                      initialValue: paciente?.inicio,
                      keyboardType: TextInputType.text,
                      onChanged: (text) => controller.onChangeValueInicio(text),
                      validator: (value) => widget.textValidator(
                        value,
                        language,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              TextFormWidget(
                key: const Key('kFechaDiagnostico'),
                controller: dateInput,
                label: language.fecha_diagnostico,
                keyboardType: TextInputType.datetime,
                suffixIcon: const Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    Icons.calendar_today,
                  ),
                ),
                onTap: () => controller.openDatePickerFechaDiagnostico(
                  context,
                  dateInput,
                ),
              ),
              if (cuidador != null)
                Column(
                  children: [
                    const Divider(),
                    TextFormWidget(
                      label: '${language.nombre} ${language.cuidador}',
                      initialValue: usuarioCuidador?.nombre != null
                          ? usuarioCuidador!.nombre
                          : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.apellido} ${language.cuidador}',
                      initialValue: usuarioCuidador?.apellido1 != null
                          ? usuarioCuidador!.apellido1
                          : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.apellido2} ${language.cuidador}',
                      initialValue: usuarioCuidador?.apellido2 != null
                          ? usuarioCuidador!.apellido2
                          : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                    TextFormWidget(
                      label: '${language.relacion} ${language.cuidador}',
                      initialValue:
                          cuidador?.relacion != null ? cuidador!.relacion : '',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              if (cuidador == null)
                Column(
                  children: [
                    const Divider(),
                    const Text(
                      'Introduzca el teléfono de contacto de su cuidador',
                    ),
                    TextFormWidget(
                      label: '${language.telefono} ${language.cuidador}',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                    ),
                    SubmitButtonWidget(
                      label: 'Enviar',
                      onPressed: () {
                        // usuario existe por teléfono => asignar usuario

                        // usuario no existe por teléfono => enviar invitación
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
