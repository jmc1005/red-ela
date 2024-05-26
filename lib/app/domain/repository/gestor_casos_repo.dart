import 'package:multiple_result/multiple_result.dart';

import '../models/gestor_casos/gestor_casos_model.dart';

abstract class GestorCasosRepo {
  Future<Result<GestorCasosModel, dynamic>> getGestorCasos();

  Future<Result<dynamic, dynamic>> addGestorCasos({
    required String hospital,
  });

  Future<Result<dynamic, dynamic>> updateGestorCasos({
    required String hospital,
    required List<String> pacientes,
  });

  Future<Result<dynamic, dynamic>> deleteGestorCasos();

  Future<Result<GestorCasosModel, dynamic>> getGestorCasosByUid(
    String uid,
  );
}
