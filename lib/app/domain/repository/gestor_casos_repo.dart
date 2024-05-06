import 'package:multiple_result/multiple_result.dart';

import '../models/gestor_casos/gestor_casos_model.dart';

abstract class GestorCasosRepo {
  Future<Result<GestorCasosModel, dynamic>> getGestorCasos();

  Future<Result<dynamic, dynamic>> addGestorCasos(
    String hospital,
  );

  Future<Result<dynamic, dynamic>> updateGestorCasos(
    String hospital,
  );

  Future<Result<dynamic, dynamic>> deleteGestorCasos();
}
