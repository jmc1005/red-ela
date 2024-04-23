import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/usuario/usuario_model.dart';
import '../../../../domain/repository/usuario_repo.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/firebase/firebase_response.dart';
import '../../../global/controllers/state/state_notifier.dart';

class UsuarioController extends StateNotifier<UsuarioModel?> {
  UsuarioController({required this.usuarioRepo}) : super(null);

  final UsuarioRepo usuarioRepo;

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

  void onChangeValueFechaNacimiento(String text) {
    final user = state!.copyWith(fechaNacimiento: text);
    onlyUpdate(user);
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

  Future<void> update(context, language) async {
    final result = await usuarioRepo.updateUsuario(
      state!.nombre,
      state!.apellido1,
      state!.apellido2,
      state!.email,
      state!.fechaNacimiento,
      state!.roles,
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
}
