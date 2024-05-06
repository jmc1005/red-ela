import 'package:multiple_result/multiple_result.dart';

import '../models/cuidador/cuidador_model.dart';

abstract class CuidadorRepo {
  Future<Result<CuidadorModel, dynamic>> getCuidador();

  Future<Result<CuidadorModel, dynamic>> findCuidadorByUid(String uidCuidador);

  Future<Result<dynamic, dynamic>> addCuidador(
    String relacion,
  );

  Future<Result<dynamic, dynamic>> updateCuidador(
    String relacion,
    List<String> pacientes,
  );

  Future<Result<dynamic, dynamic>> deleteCuidador();

  Future<Result<CuidadorModel, dynamic>> findCuidadorByEmail(String email);
}
