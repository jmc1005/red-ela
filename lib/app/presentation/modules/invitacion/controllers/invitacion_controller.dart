import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/rol/rol_model.dart';
import '../../../../domain/repository/invitacion_repo.dart';
import '../../../../domain/repository/rol_repo.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../global/controllers/state/state_notifier.dart';
import 'state/invitacion_state.dart';

class InvitacionController extends StateNotifier<InvitacionState> {
  InvitacionController(
    super._state, {
    required this.invitacionRepo,
  });

  final InvitacionRepo invitacionRepo;

  set invitacion(InvitacionState invitacion) {
    onlyUpdate(invitacion);
  }

  List<RolModel> get roles => _roles;

  set roles(roles) {
    _roles = roles;
  }

  List<DropdownMenuItem<String>> get items => _items;

  late List<RolModel> _roles = [];
  final List<DropdownMenuItem<String>> _items = [];

  Future<Result<List<RolModel>, dynamic>> getRoles(context) async {
    final rolRepo = Provider.of<RolRepo>(context);
    return rolRepo.getRoles();
  }

  void filtrarRoles(String rol) {
    if (rol == UsuarioTipo.admin.value) {
      _roles = _roles
          .where((r) =>
              r.rol == UsuarioTipo.admin.value ||
              r.rol == UsuarioTipo.gestorCasos.value)
          .toList();

      onChangeRol(UsuarioTipo.admin.value);
    } else if (rol == UsuarioTipo.paciente.value) {
      _roles = _roles
          .where(
            (r) => r.rol == UsuarioTipo.cuidador.value,
          )
          .toList();

      onChangeRol(UsuarioTipo.cuidador.value);
    } else if (rol == UsuarioTipo.gestorCasos.value) {
      _roles = _roles
          .where((r) =>
              r.rol == UsuarioTipo.paciente.value ||
              r.rol == UsuarioTipo.gestorCasos.value)
          .toList();

      onChangeRol(UsuarioTipo.paciente.value);
    }
  }

  String getEnumRolString(String rol, AppLocalizations language) {
    if (rol == UsuarioTipo.admin.value) {
      return language.admin;
    } else if (rol == UsuarioTipo.paciente.value) {
      return language.paciente;
    } else if (rol == UsuarioTipo.cuidador.value) {
      return language.cuidador;
    } else if (rol == UsuarioTipo.gestorCasos.value) {
      return language.gestor_casos;
    }

    return '';
  }

  void setItems(double width, AppLocalizations language) {
    for (final r in _roles) {
      final item = DropdownMenuItem<String>(
        value: r.rol,
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: width / 1.5,
          child: Text(
            overflow: TextOverflow.ellipsis,
            getEnumRolString(r.rol, language),
          ),
        ),
      );

      _items.add(item);
    }
  }

  void onChangeEmail(String text) {
    invitacion = state.copyWith(email: text);
  }

  void onChangeTelefono(String text) {
    invitacion = state.copyWith(telefono: text);
  }

  void onChangeRol(String text) {
    invitacion = state.copyWith(rol: text);
  }
}
