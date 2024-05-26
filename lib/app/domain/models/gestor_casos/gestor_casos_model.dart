import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'gestor_casos_model.freezed.dart';
part 'gestor_casos_model.g.dart';

@freezed
class GestorCasosModel with _$GestorCasosModel {
  const factory GestorCasosModel({
    @JsonKey(name: 'usuario_uid') required String usuarioUid,
    String? hospital,
    List<String>? pacientes,
  }) = _GestorCasosModel;

  factory GestorCasosModel.fromJson(Json json) =>
      _$GestorCasosModelFromJson(json);
}
