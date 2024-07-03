import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../utils/enums/inicio_enum.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../../utils/validators/validator_mixin.dart';
import '../../../global/widgets/text_form_widget.dart';
import '../../user/controllers/usuario_controller.dart';
import 'dropdown_tratamientos_widget.dart';

class PacientePatologiaWidget extends StatefulWidget with ValidatorMixin {
  PacientePatologiaWidget({super.key, required this.usuarioController});

  final UsuarioController usuarioController;

  @override
  State<PacientePatologiaWidget> createState() =>
      _PacientePatologiaWidgetState();
}

class _PacientePatologiaWidgetState extends State<PacientePatologiaWidget> {
  late final Future<Result<PacienteModel, dynamic>> futurePaciente;
  final inicioEnum = InicioEnum.espinal;

  final dateInput = TextEditingController();

  void _setPacienteVacio() {
    const paciente = PacienteModel(usuarioUid: '');
    if (widget.usuarioController.state!.paciente == null) {
      widget.usuarioController.paciente = paciente;
    }
  }

  Future<Result<PacienteModel, dynamic>> _getFuturePaciente() async {
    final usuarioController = widget.usuarioController;
    final uid = usuarioController.state!.usuario.uid;
    final pacienteRepo = usuarioController.pacienteController.pacienteRepo;

    return pacienteRepo.getPacienteByUid(uid);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.usuarioController;
    final language = AppLocalizations.of(context)!;

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
            if (controller.state!.paciente == null) {
              controller.paciente = result;
            }

            if (controller.state!.paciente != null) {
              if (controller.state!.paciente!.fechaDiagnostico != null &&
                  controller.state!.paciente!.fechaDiagnostico!.isNotEmpty) {
                dateInput.text = controller.state!.paciente!.fechaDiagnostico!;
              }
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
          width: MediaQuery.of(context).size.width / 1.1,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: DropdownTratamientosWidget(
                  usuarioController: controller,
                  label: language.tratamiento,
                  uuidTratamiento: controller.state!.paciente!.tratamiento,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: DropdownButtonFormField<String>(
                  value: controller.state!.paciente!.inicio,
                  borderRadius: BorderRadius.circular(8),
                  items: controller.dropdownInicioItems,
                  onChanged: (value) {
                    if (value != null) {
                      controller.onChangeValueInicio(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormWidget(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
