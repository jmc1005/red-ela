import 'package:flutter/material.dart';

import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/repository/cuidador_repo.dart';
import '../../../../domain/repository/paciente_repo.dart';
import '../../../../utils/firebase/firebase_response.dart';

class PacienteController {
  PacienteController({
    required this.context,
    required this.pacienteRepo,
    required this.cuidadorRepo,
  });

  final BuildContext context;
  final PacienteRepo pacienteRepo;
  final CuidadorRepo cuidadorRepo;

  Future<void> update(context, language, PacienteModel paciente) async {
    final result = await pacienteRepo.updatePaciente(
      paciente.tratamiento,
      paciente.fechaDiagnostico!,
      paciente.inicio,
      paciente.cuidador,
    );

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
