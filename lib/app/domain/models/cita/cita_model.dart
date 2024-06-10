import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'cita_model.freezed.dart';
part 'cita_model.g.dart';

@freezed
class CitaModel with _$CitaModel {
  const factory CitaModel({
    required String uuid,
    @JsonKey(name: 'uid_paciente') required String uidPaciente,
    @JsonKey(name: 'uid_gestor_casos') required String uidGestorCasos,
    required String asunto,
    required String fecha,
    @JsonKey(name: 'hora_inicio') required String horaInicio,
    @JsonKey(name: 'hora_fin') required String horaFin,
    required String lugar,
    String? notas,
  }) = _CitaModel;

  factory CitaModel.fromJson(Json json) => _$CitaModelFromJson(json);
}
