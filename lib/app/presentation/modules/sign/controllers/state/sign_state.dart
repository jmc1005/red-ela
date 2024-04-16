import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_state.freezed.dart';

@freezed
class SignState with _$SignState {
  const factory SignState({
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default('') String confirmPassword,
    @Default(true) bool obscureConfirmPassword,
  }) = _SignState;
}
