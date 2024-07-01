import 'package:multiple_result/multiple_result.dart';

import '../models/paciente/paciente_model.dart';

abstract class PacienteRepo {
  Future<Result<PacienteModel, dynamic>> getPaciente();

  Future<Result<dynamic, dynamic>> addPaciente({
    required String tratamiento,
    required String fechaDiagnostico,
    required String inicio,
    String? cuidador,
    String? gestorCasos,
  });

  Future<Result<dynamic, dynamic>> updatePaciente({
    required String tratamiento,
    required String fechaDiagnostico,
    required String inicio,
    String? cuidador,
    String? gestorCasos,
  });

  Future<Result<List<String>, dynamic>> getAllPacientesByUidCuidador({
    required String uidCuidador,
    required String email,
  });

  Future<Result<PacienteModel, dynamic>> getPacienteByUid(String uid);

  Future<void> relacionaPacienteCuidador({
    required String uidPaciente,
  });

  Future<Result<dynamic, dynamic>> deletePaciente();

  Future<Result<dynamic, dynamic>> deletePacienteByUid({required uid});
}
