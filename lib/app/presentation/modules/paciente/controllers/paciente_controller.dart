import 'package:flutter/material.dart';

import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/repository/paciente_repo.dart';
import '../../../../utils/firebase/firebase_response.dart';

class PacienteController {
  PacienteController({
    required this.context,
    required this.pacienteRepo,
  });

  final BuildContext context;
  final PacienteRepo pacienteRepo;

  Future<void> update(context, language, PacienteModel paciente) async {
    final result = await pacienteRepo.addPaciente(
        tratamiento: paciente.tratamiento!,
        fechaDiagnostico: paciente.fechaDiagnostico!,
        inicio: paciente.inicio!,
        cuidador: paciente.cuidador,
        gestorCasos: paciente.gestorCasos);

    late String code;
    late bool isSuccess = true;

    result.when((success) {
      code = success;
    }, (error) {
      code = error;
      isSuccess = false;
    });

    final response = FirebaseResponse(
      context: context,
      language: language,
      code: code,
    );

    if (isSuccess) {
      response.showSuccess();
    } else {
      response.showError();
    }
  }
}
