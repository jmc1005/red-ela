import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'cita_model.freezed.dart';
part 'cita_model.g.dart';

@freezed
class CitaModel with _$CitaModel {
  const factory CitaModel({
    @JsonKey(name: 'uid') required String uid,
    required String asunto,
    required String fechaInicio,
    required String fechaFin,
    
    required String horaInicio,
    required String horaFin,
    required String lugar,
    @JsonKey(name: 'uid_paciente') required String uidPaciente,
    String? notas,
  }) = _CitaModel;

  factory CitaModel.fromJson(Json json) => _$CitaModelFromJson(json);
}
