import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'usuario_model.freezed.dart';
part 'usuario_model.g.dart';

@freezed
class UsuarioModel with _$UsuarioModel {
  const factory UsuarioModel(
    String uid,
    String nombre,
    String apellido1,
    String apellido2,
    String email,
    List<String> roles,
  ) = _UsuarioModel;

  factory UsuarioModel.fromJson(Json json) => _$UsuarioModelFromJson(json);
}
