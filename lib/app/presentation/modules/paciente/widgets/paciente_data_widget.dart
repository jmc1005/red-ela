import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/validators/validator_mixin.dart';
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
      final cuidador = paciente.cuidador!;

      if (cuidador.usuarioUid != null && cuidador.usuarioUid!.isNotEmpty) {
        final resultCuidador =
            await cuidadorRepo.findCuidadorByUid(cuidador.usuarioUid!);

        resultCuidador.when(
          (success) => controller.paciente = paciente.copyWith(
            cuidador: success,
          ),
          (error) => _showError(error, language),
        );
      } else if (cuidador.email != null && cuidador.email!.isNotEmpty) {
        final resultCuidador =
            await cuidadorRepo.findCuidadorByEmail(cuidador.email!);

        resultCuidador.when(
          (success) => controller.paciente = paciente.copyWith(
            cuidador: success,
          ),
          (error) => _showError(error, language),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

    PacienteModel? paciente = controller.state?.paciente;
    CuidadorModel? cuidador = controller.state?.paciente?.cuidador;

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
            cuidador = controller.state!.paciente!.cuidador;

            if (paciente!.fechaDiagnostico != null &&
                paciente!.fechaDiagnostico!.isNotEmpty) {
              dateInput.text = paciente!.fechaDiagnostico!;
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
              const SizedBox(height: 8),
              TextFormWidget(
                label: '${language.nombre} ${language.cuidador}',
                initialValue: cuidador?.nombre != null ? cuidador!.nombre : '',
                keyboardType: TextInputType.text,
                onChanged: (text) => controller.onChangeTratamiento(text),
                validator: (value) => widget.textValidator(
                  value,
                  language,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
