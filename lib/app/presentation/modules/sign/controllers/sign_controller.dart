import 'package:red_ela/app/presentation/global/controllers/state/state_notifier.dart';
import 'package:red_ela/app/presentation/modules/sign/controllers/state/sign_state.dart';

class SignController extends StateNotifier<SignState> {
  SignController(super.state);

  set sign(SignState state) {
    this.state = state;
  }

  void onEmailChanged(String text) {
    final email = text.trim().toLowerCase();
    onlyUpdate(state.copyWith(email: email));
  }

  void onPasswordChanged(String text) {
    final password = text.trim();
    onlyUpdate(state.copyWith(password: password));
  }

  void onVisibilityPasswordChanged(bool visible) {
    onlyUpdate(state.copyWith(obscurePassword: visible));
  }

  void onVisibilityConfirmPasswordChanged(bool visible) {
    onlyUpdate(state.copyWith(obscureConfirmPassword: visible));
  }
}
