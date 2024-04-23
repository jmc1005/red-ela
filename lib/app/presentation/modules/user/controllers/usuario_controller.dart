import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../global/controllers/state/state_notifier.dart';

class UsuarioController extends StateNotifier<UsuarioModel?> {
  UsuarioController() : super(null);

  set usuarioModel(UsuarioModel usuarioModel) {
    state = usuarioModel;
    onlyUpdate(state);
  }

  void onChangeValueNombre(String text) {
    final user = state!.copyWith(nombre: text);
    onlyUpdate(user);
  }

  void onChangeValueApellido1(String text) {
    final user = state!.copyWith(apellido1: text);
    onlyUpdate(user);
  }

  void onChangeValueApellido2(String text) {
    final user = state!.copyWith(apellido2: text);
    onlyUpdate(user);
  }

  void onChangeValueEmail(String text) {
    final user = state!.copyWith(email: text);
    onlyUpdate(user);
  }
}
