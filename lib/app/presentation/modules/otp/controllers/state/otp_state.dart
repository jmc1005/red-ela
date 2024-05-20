import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

@freezed
class OTPState with _$OTPState {
  const factory OTPState({
    @Default('') String phoneNumber,
    @Default('') String verificationId,
    @Default('') String code,
    @Default(false) bool visible,
  }) = _OTPState;
}
