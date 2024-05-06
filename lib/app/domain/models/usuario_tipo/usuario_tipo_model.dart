import 'package:freezed_annotation/freezed_annotation.dart';

import '../cuidador/cuidador_model.dart';
import '../gestor_casos/gestor_casos_model.dart';
import '../paciente/paciente_model.dart';
import '../typedefs.dart';
import '../usuario/usuario_model.dart';

part 'usuario_tipo_model.freezed.dart';
part 'usuario_tipo_model.g.dart';

@freezed
class UsuarioTipoModel with _$UsuarioTipoModel {
  const factory UsuarioTipoModel({
    required UsuarioModel usuario,
    PacienteModel? paciente,
    CuidadorModel? cuidador,
    GestorCasosModel? gestorCasos,
  }) = _UsuarioTipoModel;

  factory UsuarioTipoModel.fromJson(Json json) =>
      _$UsuarioTipoModelFromJson(json);
}
