import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'rol_model.freezed.dart';
part 'rol_model.g.dart';

@freezed
class RolModel with _$RolModel {
  const factory RolModel(
    @JsonKey(name: 'rol_id') String rolId,
    String descripcion,
  ) = _RolModel;

  factory RolModel.fromJson(Json json) => _$RolModelFromJson(json);
}
