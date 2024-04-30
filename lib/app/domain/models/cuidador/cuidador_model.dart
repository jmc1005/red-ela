import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'cuidador_model.freezed.dart';
part 'cuidador_model.g.dart';

@freezed
class CuidadorModel with _$CuidadorModel {
  const factory CuidadorModel(
    @JsonKey(name: 'usuario_uid') String? usuarioUid,
    String? nombre,
    String? apellido1,
    String? apellido2,
    String? email,
    String? telefono,
    List<String>? pacientes,
    String relacion,
  ) = _CuidadorModel;

  factory CuidadorModel.fromJson(Json json) => _$CuidadorModelFromJson(json);
}
