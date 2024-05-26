import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_constants.dart';
import '../typedefs.dart';

part 'usuario_model.freezed.dart';
part 'usuario_model.g.dart';

@freezed
class UsuarioModel with _$UsuarioModel {
  const factory UsuarioModel({
    required String uid,
    String? nombre,
    String? apellido1,
    String? apellido2,
    @JsonKey(name: 'nombre_completo') String? nombreCompleto,
    String? email,
    String? telefono,
    String? password,
    @JsonKey(name: 'fecha_nacimiento', readValue: readFechaNacimiento)
    String? fechaNacimiento,
    required String rol,
  }) = _UsuarioModel;

  factory UsuarioModel.fromJson(Json json) => _fromJson(json);
}

UsuarioModel _fromJson(Json json) {
  final nombre = json['nombre'] ?? '';
  final apellido1 = json['apellido1'] ?? '';
  final apellido2 = json['apellido2'] ?? '';

  final nombreCompleto = '$nombre $apellido1 $apellido2';
  json['nombre_completo'] = nombreCompleto;

  return _$UsuarioModelFromJson(json);
}

Object? readFechaNacimiento(Map map, String _) {
  final value = map['fecha_nacimiento'];

  if (value == null) {
    return '';
  }

  final timestamp = value as Timestamp;
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  final fechaNacimiento = DateFormat(AppConstants.formatDate).format(date);

  return fechaNacimiento;
}
