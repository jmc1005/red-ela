import 'package:multiple_result/multiple_result.dart';

import '../models/cuidador/cuidador_model.dart';
import '../models/usuario/usuario_model.dart';

abstract class CuidadorRepo {
  Future<Result<CuidadorModel, dynamic>> getCuidador();

  Future<Result<UsuarioModel, dynamic>> getUsuarioCuidadorByUid(String uid);

  Future<Result<CuidadorModel, dynamic>> findCuidadorByUid(String uidCuidador);

  Future<Result<dynamic, dynamic>> addCuidador({
    required String relacion,
  });

  Future<Result<dynamic, dynamic>> updateCuidador({
    required String relacion,
    List<String> pacientes,
  });

  Future<Result<dynamic, dynamic>> deleteCuidador();

  Future<Result<CuidadorModel, dynamic>> findCuidadorByEmail(String email);

  Future<void> updateCuidadorRelacion({required String solicitado});
}
