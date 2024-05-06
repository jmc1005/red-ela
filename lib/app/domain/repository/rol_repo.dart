import 'package:multiple_result/multiple_result.dart';

import '../models/rol/rol_model.dart';

abstract class RolRepo {
  Future<Result<RolModel, dynamic>> getRol(String uuid);

  Future<Result<dynamic, dynamic>> addRol(
    String rol,
    String descripcion,
  );

  Future<Result<dynamic, dynamic>> updateRol(
    String uuid,
    String rol,
    String descripcion,
  );

  Future<Result<dynamic, dynamic>> deleteRol(String rol);
}
