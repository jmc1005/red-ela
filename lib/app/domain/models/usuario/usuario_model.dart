import 'package:freezed_annotation/freezed_annotation.dart';

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
    @JsonKey(name: 'nombre_completo') required String nombreCompleto,
    String? email,
    String? telefono,
    String? password,
    @JsonKey(name: 'fecha_nacimiento') String? fechaNacimiento,
    required String rol,
  }) = _UsuarioModel;

  factory UsuarioModel.fromJson(Json json) => _$UsuarioModelFromJson(json);
}

// Object? readFechaNacimiento(Map map, String _) {
//   final value = map['fecha_nacimiento'];

//   if (value == null) {
//     return '';
//   }

//   final timestamp = value as Timestamp;
//   final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//   final fechaNacimiento = DateFormat(AppConstants.formatDate).format(date);

//   return fechaNacimiento;
// }
