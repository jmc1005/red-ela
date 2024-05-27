import 'package:freezed_annotation/freezed_annotation.dart';

part 'invitacion_state.freezed.dart';

@freezed
class InvitacionState with _$InvitacionState {
  const factory InvitacionState({
    @Default('') String email,
    @Default('') String telefono,
    @Default('') String rol,
  }) = _InvitacionState;
}
