import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'tratamiento_model.freezed.dart';
part 'tratamiento_model.g.dart';

@freezed
class TratamientoModel with _$TratamientoModel {
  const factory TratamientoModel({
    required String uuid,
    required String tratamiento,
  }) = _TratamientoModel;

  factory TratamientoModel.fromJson(Json json) =>
      _$TratamientoModelFromJson(json);
}
