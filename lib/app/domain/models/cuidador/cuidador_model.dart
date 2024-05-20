import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'cuidador_model.freezed.dart';
part 'cuidador_model.g.dart';

@freezed
class CuidadorModel with _$CuidadorModel {
  const factory CuidadorModel({
    @JsonKey(name: 'usuario_uid') required String usuarioUid,
    List<String>? pacientes,
    @Default('') String relacion,
  }) = _CuidadorModel;

  factory CuidadorModel.fromJson(Json json) => _$CuidadorModelFromJson(json);
}
