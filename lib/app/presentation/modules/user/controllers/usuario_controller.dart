import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/cuidador/cuidador_model.dart';
import '../../../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../../../domain/models/paciente/paciente_model.dart';
import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/models/usuario_tipo/usuario_tipo_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/enums/usuario_tipo.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';
import '../../paciente/controllers/paciente_controller.dart';

class UsuarioController extends StateNotifier<UsuarioTipoModel?> {
  UsuarioController({
    required this.context,
    required this.usuarioRepo,
    this.pacienteController,
  }) : super(null);

  final BuildContext context;
  final UsuarioRepo usuarioRepo;
  final PacienteController? pacienteController;

  set usuario(UsuarioModel usuarioModel) {
    final usuarioTipoModel = UsuarioTipoModel(usuario: usuarioModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set paciente(PacienteModel pacienteModel) {
    final usuarioTipoModel = state!.copyWith(paciente: pacienteModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set cuidador(CuidadorModel cuidadorModel) {
    final usuarioTipoModel = state!.copyWith(cuidador: cuidadorModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  set gestorCasos(GestorCasosModel gestorCasosModel) {
    final usuarioTipoModel = state!.copyWith(gestorCasos: gestorCasosModel);
    state = usuarioTipoModel;
    onlyUpdate(state);
  }

  void onChangeValueNombre(String text) {
    usuario = state!.usuario.copyWith(nombre: text);
  }

  void onChangeValueApellido1(String text) {
    usuario = state!.usuario.copyWith(apellido1: text);
  }

  void onChangeValueApellido2(String text) {
    usuario = state!.usuario.copyWith(apellido2: text);
  }

  void onChangeValueEmail(String text) {
    usuario = state!.usuario.copyWith(email: text);
  }

  void onChangeValueFechaNacimiento(String text) {
    usuario = state!.usuario.copyWith(fechaNacimiento: text);
  }

  void onChangeValueTipo(String text) {
    usuario = state!.usuario.copyWith(rol: text);
  }

  void onChangeTratamiento(String text) {
    paciente = state!.paciente!.copyWith(tratamiento: text);
  }

  void onChangeValueInicio(String text) {
    paciente = state!.paciente!.copyWith(inicio: text);
  }

  void onChangeValueFechaDiagnostico(String text) {
    paciente = state!.paciente!.copyWith(fechaDiagnostico: text);
  }

  Future<void> openDatePicker(
    BuildContext context,
    TextEditingController dateInput,
  ) async {
    final language = AppLocalizations.of(context)!;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: Locale(language.localeName),
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String date = DateFormat(
        AppConstants.formatDate,
      ).format(
        pickedDate,
      );

      onChangeValueFechaNacimiento(date);
      dateInput.text = date;
    } else {}
  }

  Future<void> openDatePickerFechaDiagnostico(
    BuildContext context,
    TextEditingController dateInput,
  ) async {
    final language = AppLocalizations.of(context)!;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: Locale(language.localeName),
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String date = DateFormat(
        AppConstants.formatDate,
      ).format(
        pickedDate,
      );

      onChangeValueFechaDiagnostico(date);
      dateInput.text = date;
    } else {}
  }

  Future<void> update(context, language) async {
    final result = await usuarioRepo.updateUsuario(
      state!.usuario.nombre!,
      state!.usuario.apellido1!,
      state!.usuario.apellido2!,
      state!.usuario.email,
      state!.usuario.fechaNacimiento!,
      state!.usuario.rol!,
    );

    late String code;
    late bool isSuccess = true;

    result.when((success) {
      code = success;
    }, (error) {
      code = error;
      isSuccess = false;
    });

    final response = FirebaseResponse(
      context: context,
      language: language,
      code: code,
    );

    if (isSuccess) {
      response.showSuccess();
    } else {
      response.showError();
    }
  }

  List<DropdownMenuItem<String>> get typeList {
    final language = AppLocalizations.of(context)!;

    return UsuarioTipo.values.map<DropdownMenuItem<String>>(
      (UsuarioTipo type) {
        final label = getEnumTypeString(type, language);

        return DropdownMenuItem<String>(
          value: type.value,
          alignment: Alignment.centerLeft,
          child: Text(label),
        );
      },
    ).toList();
  }

  String getEnumTypeString(UsuarioTipo enumValue, AppLocalizations language) {
    switch (enumValue) {
      case UsuarioTipo.cuidador:
        return language.cuidador;
      case UsuarioTipo.paciente:
        return language.paciente;
      // case UsuarioTipo.gestorCasos:
      //   return language.gestor_casos;
      // case UsuarioTipo.gestor:
      //   return language.gestor_casos;
      // case UsuarioTipo.admin:
      //   return language.gestor_casos;
    }
  }
}