import 'package:multiple_result/multiple_result.dart';

import '../models/cita/cita_model.dart';

abstract class CitaRepo {
  Future<Result<CitaModel, dynamic>> getCita({required String uuid});

  Future<Result<List<CitaModel>, dynamic>> getCitas();

  Future<Result<dynamic, dynamic>> addCita({
    required String uidPaciente,
    required String asunto,
    required String fecha,
    required String horaInicio,
    required String horaFin,
    required String lugar,
    String? notas,
  });

  Future<Result<dynamic, dynamic>> updateCita({
    required String uuid,
    required String uidPaciente,
    required String asunto,
    required String fecha,
    required String horaInicio,
    required String horaFin,
    required String lugar,
    String? notas,
  });

  Future<Result<dynamic, dynamic>> deleteCita({required String uuid});
}
