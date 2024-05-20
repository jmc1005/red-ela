import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_constants.dart';
import '../cuidador/cuidador_model.dart';
import '../typedefs.dart';

part 'paciente_model.freezed.dart';
part 'paciente_model.g.dart';

@freezed
class PacienteModel with _$PacienteModel {
  const factory PacienteModel({
    @JsonKey(name: 'usuario_uid') required String usuarioUid,
    String? tratamiento,
    @JsonKey(
      name: 'fecha_diagnostico',
      readValue: readFechaDiagnostico,
    )
    String? fechaDiagnostico,
    String? inicio,
    @JsonKey(name: 'cuidador') CuidadorModel? cuidador,
  }) = _PacienteModel;

  factory PacienteModel.fromJson(Json json) => _$PacienteModelFromJson(json);
}

Object? readFechaDiagnostico(Map map, String _) {
  final value = map['fecha_nacimiento'];

  if (value == null) {
    return '';
  }

  final timestamp = value as Timestamp;
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  final fechaDiagnostico = DateFormat(AppConstants.formatDate).format(date);

  return fechaDiagnostico;
}
