import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'invitacion_model.freezed.dart';
part 'invitacion_model.g.dart';

@freezed
class InvitacionModel with _$InvitacionModel {
  const factory InvitacionModel({
    required String rol,
    required String solicitado,
    required String estado,
  }) = _InvitacionModel;

  factory InvitacionModel.fromJson(Json json) =>
      _$InvitacionModelFromJson(json);
}
