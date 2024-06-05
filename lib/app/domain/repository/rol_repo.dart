import 'package:multiple_result/multiple_result.dart';

import '../models/rol/rol_model.dart';

abstract class RolRepo {
  Future<Result<RolModel, dynamic>> getRol({required String uuid});

  Future<Result<List<RolModel>, dynamic>> getRoles();

  Future<Result<dynamic, dynamic>> addRol({
    required String rol,
    required String descripcion,
  });

  Future<Result<dynamic, dynamic>> updateRol({
    required String uuid,
    required String rol,
    required String descripcion,
  });

  Future<Result<dynamic, dynamic>> deleteRol({required String uuid});
}
