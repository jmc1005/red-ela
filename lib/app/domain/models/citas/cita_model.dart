import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'cita_model.freezed.dart';
part 'cita_model.g.dart';

@freezed
class CitaModel with _$CitaModel {
  const factory CitaModel({
    @JsonKey(name: 'uid_paciente') required String uidPaciente,
    @JsonKey(name: 'uid_gestor_casos') required String uidGestorCasos,
    required String asunto,
    required String fechaInicio,
    required String horaInicio,
    required String fechaFin,
    required String horaFin,
    required String lugar,
    String? notas,
  }) = _CitaModel;

  factory CitaModel.fromJson(Json json) => _$CitaModelFromJson(json);
}
