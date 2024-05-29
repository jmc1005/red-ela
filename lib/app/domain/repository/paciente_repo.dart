import 'package:multiple_result/multiple_result.dart';

import '../models/cuidador/cuidador_model.dart';
import '../models/paciente/paciente_model.dart';

abstract class PacienteRepo {
  Future<Result<PacienteModel, dynamic>> getPaciente();

  Future<Result<dynamic, dynamic>> addPaciente({
    required String tratamiento,
    required String fechaDiagnostico,
    required String inicio,
    CuidadorModel? cuidador,
  });

  Future<Result<dynamic, dynamic>> updatePaciente({
    required String tratamiento,
    required String fechaDiagnostico,
    required String inicio,
    CuidadorModel? cuidador,
  });

  Future<Result<dynamic, dynamic>> deletePaciente();

  Future<Result<List<String>, dynamic>> getAllPacientesByUidCuidador({
    required String uidCuidador,
    required String email,
  });

  Future<void> updatePacienteRelacion({required String solicitado});

  Future<Result<PacienteModel, dynamic>> getPacienteByUid(String uid);

  Future<void> addCuidador({
    required String uidPaciente,
    required String uidCuidador,
  });
}
