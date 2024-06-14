import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'hospital_model.freezed.dart';
part 'hospital_model.g.dart';

@freezed
class HospitalModel with _$HospitalModel {
  const factory HospitalModel({
    required String uuid,
    required String hospital,
  }) = _HospitalModel;

  factory HospitalModel.fromJson(Json json) => _$HospitalModelFromJson(json);
}
