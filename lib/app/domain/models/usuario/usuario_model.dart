import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_constants.dart';
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
    @JsonKey(name: 'fecha_nacimiento', readValue: readFechaNacimiento)
    String fechaNacimiento,
    @JsonKey(name: 'roles', readValue: readRoles) List<String> roles,
  ) = _UsuarioModel;

  factory UsuarioModel.fromJson(Json json) => _$UsuarioModelFromJson(json);
}

Object? readRoles(Map map, String _) {
  final list = map['roles'];

  return jsonDecode(list).cast<String>().toList();
}

Object? readFechaNacimiento(Map map, String _) {
  final timestamp = map['fecha_nacimiento'] as Timestamp;
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  final fechaNacimiento = DateFormat(AppConstants.formatDate).format(date);

  return fechaNacimiento;
}
