import 'package:multiple_result/multiple_result.dart';

import '../models/gestor_casos/gestor_casos_model.dart';

abstract class GestorCasosRepo {
  Future<Result<GestorCasosModel, dynamic>> getGestorCasos();

  Future<Result<dynamic, dynamic>> addGestorCasos({
    required String hospital,
  });

  Future<Result<dynamic, dynamic>> updateGestorCasos({
    required String hospital,
  });

  Future<Result<GestorCasosModel, dynamic>> getGestorCasosByUid(
    String uid,
  );

  Future<void> relacionaGestorCasosPaciente({
    required String uidGestorCasos,
  });

  Future<Result<dynamic, dynamic>> deleteGestorCasos();

  Future<Result<dynamic, dynamic>> deleteGestorCasosByUid({
    required String uid,
  });
}
