import 'package:multiple_result/multiple_result.dart';

import '../models/cuidador/cuidador_model.dart';

abstract class CuidadorRepo {
  Future<Result<CuidadorModel, dynamic>> getCuidador();

  Future<Result<CuidadorModel, dynamic>> getCuidadorByUid(String uidCuidador);

  Future<Result<dynamic, dynamic>> addCuidador({
    required String relacion,
    String? paciente,
  });

  Future<Result<dynamic, dynamic>> updateCuidador({
    required String relacion,
    String? paciente,
  });

  Future<Result<dynamic, dynamic>> deleteCuidador();

  Future<Result<dynamic, dynamic>> deleteCuidadorByUid({
    required String uid,
  });
}
