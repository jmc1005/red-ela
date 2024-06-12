import 'package:multiple_result/multiple_result.dart';

import '../models/tratamiento/tratamiento_model.dart';

abstract class TratamientoRepo {
  Future<Result<TratamientoModel, dynamic>> getTratamiento(
      {required String uuid});

  Future<Result<List<TratamientoModel>, dynamic>> getTratamientos();

  Future<Result<dynamic, dynamic>> addTratamiento({
    required String tratamiento,
    required String descripcion,
  });

  Future<Result<dynamic, dynamic>> updateTratamiento({
    required String uuid,
    required String tratamiento,
    required String descripcion,
  });

  Future<Result<dynamic, dynamic>> deleteTratamiento({required String uuid});
}
